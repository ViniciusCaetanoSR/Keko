public with sharing class IntegrationTotvsService {

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

        if(conta == null) {
            System.debug('Conta não encontrada: ' + idConta);
            return;
        }

        TotvsBody requestBody = TotvsBodyMapper.totvsMapper(conta);

        String requestBodyJson = JSON.serialize(requestBody);

        System.debug('REQUEST BODY: ' + requestBodyJson);

        requestTotvs(requestBodyJson, idConta);
    }

    @future(callout=true)
    public static void requestTotvs(String requestBodyJson, String idConta) {

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

                // Ativar o bypass antes da atualização para evitar disparo de trigger
                AccountTriggerHandler.bypassTrigger = true;
                
                Account conta = AccountSelector.selectAccountById(idConta);
                if(conta != null) {
                    conta.IntegracaoTotvs__c = true;
                    conta.Codigo_do_cliente__c = customerCode;
                    update conta;
                }
                
                // Redefinir o bypass após a atualização
                AccountTriggerHandler.bypassTrigger = false;
                
            } else {
                System.debug('Erro ao enviar dados: ' + response.getStatus());
                System.debug('Resposta: ' + response.getBody());
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

                requestPutTotvs(requestBodyJson, conta.Codigo_do_cliente__c);
            } else {
                System.debug('Conta não possui código do cliente para atualização.');
            }
        }
    }

    @future(callout=true)
    public static void requestPutTotvs(String requestBodyJson, String codigoCliente) {

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
            }
        } catch (Exception e) {
            System.debug('Exceção ao atualizar dados: ' + e.getMessage());
        }
    }
}
