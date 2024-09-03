public with sharing class IntegrationTotvsService {

    public static final Integer MAX_RETRY_COUNT = 1;

    public static void enviarDadosTotvs(String idConta) {

        System.debug('Iniciando envio de dados para Totvs com idConta: ' + idConta);

        Account conta = AccountSelector.selectAccountById(idConta);
        
        if (conta != null) {
            System.debug('Conta encontrada: ' + conta);
            enviarIntegracao(conta.Id);
        }
    }
    
    public static void enviarIntegracao(String idConta) {
        
        System.debug('Iniciando mapeamento da conta para TotvsBody');

        Account conta = AccountSelector.selectAccountById(idConta);
	
        System.debug('CONTA: ' + conta);
        	
        if(conta == null) {
            System.debug('Conta não encontrada: ' + idConta);
            return;
        }

        TotvsBody requestBody = TotvsBodyMapper.totvsMapper(conta);
        System.debug(requestBody);

        String requestBodyJson = JSON.serialize(requestBody);

        System.debug('REQUEST BODY: ' + requestBodyJson);

        requestTotvs(requestBodyJson, idConta, 0);
    }

    public static void retryRequest (String requestBodyJson, String idConta) {

        System.debug('Iniciando retentativa request POST para Totvs API');

        TotvsAPI__c totvsApi = TotvsAPI__c.getValues('accesses');

        HttpRequest request = new HttpRequest();
            request.setEndpoint(totvsApi.base_URL__c);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');

            String credentials = totvsApi.username__c + ':' + totvsApi.password__c;
            String encodedCredentials = EncodingUtil.base64Encode(Blob.valueOf(credentials));
            request.setHeader('Authorization', 'Basic ' + encodedCredentials);
            
            request.setBody(requestBodyJson);
            request.setTimeout(120000);
            
            Http http = new Http();
            HttpResponse response = http.send(request);

            System.debug('Response Status Code: ' + response.getStatusCode());
            if (response.getStatusCode() == 201) {
                System.debug('Dados enviados com sucesso: ' + requestBodyJson);

                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Integer customerCodeInt = (Integer) responseMap.get('customerCode');
                String customerCode = String.valueOf(customerCodeInt);
                System.debug('Customer Code recebido: ' + customerCode);
                
                Account conta = AccountSelector.selectAccountById(idConta);
                if(conta != null) {
                    conta.IntegracaoTotvs__c = true;
                    conta.Codigo_do_cliente__c = customerCode;
                    update conta;
                }
            } else {
                System.debug('Erro ao enviar dados: ' + response.getStatus());
                System.debug('Resposta: ' + response.getBody());
                System.debug('REQUEST' + requestBodyJson);
            }
    }

    @future(callout=true)
    public static void requestTotvs(String requestBodyJson, String idConta, Integer retryCount) {

        System.debug('Iniciando request POST para Totvs API');

        TotvsAPI__c totvsApi = TotvsAPI__c.getValues('accesses');

        try {
            HttpRequest request = new HttpRequest();
            request.setEndpoint(totvsApi.base_URL__c);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');

            String credentials = totvsApi.username__c + ':' + totvsApi.password__c;
            String encodedCredentials = EncodingUtil.base64Encode(Blob.valueOf(credentials));
            request.setHeader('Authorization', 'Basic ' + encodedCredentials);
            
            request.setBody(requestBodyJson);
            request.setTimeout(120000);
            
            Http http = new Http();
            HttpResponse response = http.send(request);

            System.debug('Response Status Code: ' + response.getStatusCode());
            if (response.getStatusCode() == 201) {
                System.debug('Dados enviados com sucesso: ' + requestBodyJson);

                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Integer customerCodeInt = (Integer) responseMap.get('customerCode');
                String customerCode = String.valueOf(customerCodeInt);
                System.debug('Customer Code recebido: ' + customerCode);
                
                Account conta = AccountSelector.selectAccountById(idConta);
                if(conta != null) {
                    conta.IntegracaoTotvs__c = true;
                    conta.Codigo_do_cliente__c = customerCode;
                    update conta;
                }
            } else {
                System.debug('Erro ao enviar dados: ' + response.getStatus());
                System.debug('Resposta: ' + response.getBody());
                System.debug('REQUEST' + requestBodyJson);

                for (Integer i = 0; i <= MAX_RETRY_COUNT; i++) {
                    System.debug('Nova tentativa de registrar as informações no TOTVS. Tentativa de número: ' + (i));
                    retryRequest(requestBodyJson, idConta); 

                    if (i == MAX_RETRY_COUNT) {
                    System.debug('Número máximo de tentativas foi alcançado.');
                    CreateLogRecord.createLog(idConta, requestBodyJson, response.getBody());
                    }
                }
            }
        } catch (Exception e) {
            System.debug('Exceção ao enviar dados: ' + e.getMessage());
        }
    }

    public static void updateTotvs(List<Account> updatedAccounts) {

        for (Account conta : updatedAccounts) {


            if(String.isNotBlank(conta.Codigo_do_cliente__c)) {

                TotvsBody requestBody = TotvsBodyMapper.totvsMapper(conta);
                String requestBodyJson = JSON.serialize(requestBody);

                System.debug('Request Body Atualização: ' + requestBodyJson);

                requestPutTotvs(requestBodyJson, conta.Codigo_do_cliente__c, 0);
            } else {
                System.debug('Conta não possui código do cliente para atualização.');
            }
        }
    }

    public static void retryPutTotvs (String requestBodyJson, String codigoCliente) {

        System.debug('Envio de atualizaçã de Conta para TOTVS');

        TotvsAPI__c totvsApi = TotvsAPI__c.getValues('accesses');

        HttpRequest request = new HttpRequest();
            request.setEndpoint(totvsApi.base_URL__c + '/' + codigoCliente);
            request.setMethod('PUT');
            request.setHeader('Content-Type', 'application/json');

            String credentials = totvsApi.username__c + ':' + totvsApi.password__c;
            String encodedCredentials = EncodingUtil.base64Encode(Blob.valueOf(credentials));
            request.setHeader('Authorization', 'Basic ' + encodedCredentials);
            
            request.setBody(requestBodyJson);
            request.setTimeout(120000);
            
            Http http = new Http();
            HttpResponse response = http.send(request);

            System.debug('Código do status da Resposta: ' + response.getStatusCode());

            if (response.getStatusCode() == 200) {
                System.debug('Dados atualizados com sucesso! | ' + requestBodyJson);
                //System.debug('Request: '+  requestBodyJson); 
            } else {
                System.debug('Erro ao atualizar dados: ' + response.getStatus());
                System.debug('Resposta: ' + response.getBody());
            }
    }

    @future(callout=true)
    public static void requestPutTotvs(String requestBodyJson, String codigoCliente, Integer retryCount) {

        if (retryCount == null) {
            retryCount = 0;
        }

        System.debug('Envio de atualizaçã de Conta para TOTVS');

        TotvsAPI__c totvsApi = TotvsAPI__c.getValues('accesses');

        try {
            HttpRequest request = new HttpRequest();
            request.setEndpoint(totvsApi.base_URL__c + '/' + codigoCliente);
            request.setMethod('PUT');
            request.setHeader('Content-Type', 'application/json');

            String credentials = totvsApi.username__c + ':' + totvsApi.password__c;
            String encodedCredentials = EncodingUtil.base64Encode(Blob.valueOf(credentials));
            request.setHeader('Authorization', 'Basic ' + encodedCredentials);
            
            request.setBody(requestBodyJson);
            request.setTimeout(120000);
            
            Http http = new Http();
            HttpResponse response = http.send(request);

            System.debug('Código do status da Resposta: ' + response.getStatusCode());

            if (response.getStatusCode() == 200) {
                System.debug('Dados atualizados com sucesso! | ' + requestBodyJson);
                //System.debug('Request: '+  requestBodyJson); 
            } else {
                System.debug('Erro ao atualizar dados: ' + response.getStatus());
                System.debug('Resposta: ' + response.getBody());

                for(Integer i = 0; i <= MAX_RETRY_COUNT; i++) {
                    System.debug('Tentando novamente atualizar registro. Tentativa de número: ' + i );
                    retryPutTotvs(requestBodyJson, codigoCliente);
                    
                    if(i == MAX_RETRY_COUNT) {
                        System.debug('Número máximo de tentativas atingido');
                        Account conta = [SELECT Id, Name FROM ACCOUNT WHERE Codigo_do_cliente__c = :codigoCliente LIMIT 1];
                        CreateLogRecord.createLog(conta.Id, requestBodyJson, response.getBody());
                    }
                }
            }
        } catch (Exception e) {
            System.debug('Exceção ao atualizar dados: ' + e.getMessage());
        }
    }
}