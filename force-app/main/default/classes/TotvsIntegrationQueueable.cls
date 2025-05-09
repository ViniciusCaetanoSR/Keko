public class TotvsIntegrationQueueable implements Queueable, Database.AllowsCallouts {

    private String accountId;
    private Integer retryCount;
    private Boolean isUpdate;
    
    public TotvsIntegrationQueueable(String accountId, Integer retryCount, Boolean isUpdate) {
        this.accountId = accountId;
        this.retryCount = retryCount;
        this.isUpdate = isUpdate;
    }

    public void execute(QueueableContext context) {

        try {

            HttpRequest request = new HttpRequest();
            Http http = new Http();
            HttpResponse response;
            TotvsAPI__c totvsApi = TotvsAPI__c.getValues('accesses');

            Account account = AccountSelector.selectAccountById(accountId);

            if (account == null) {  return; }

            TotvsBody requestBodyJson = TotvsBodyMapper.totvsMapper(account);
            String credentials = totvsApi.username__c + ':' + totvsApi.password__c;
            String encodedCredentials = EncodingUtil.base64Encode(Blob.valueOf(credentials));

            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Basic ' + encodedCredentials);
            request.setBody(JSON.serialize(requestBodyJson));
            request.setTimeout(120000); //2 minutos

            if (isUpdate) { // Se for atualização (PUT)
                
                request.setMethod('PUT');
                request.setEndpoint(totvsApi.base_URL__c + '/' + account.Codigo_do_cliente__c);
                System.debug('Enviando PUT para Totvs com código do cliente: ' + account.Codigo_do_cliente__c);

            } else { // Se for inserção (POST)

                request.setMethod('POST');
                request.setEndpoint(totvsApi.base_URL__c);
                System.debug('Enviando POST para Totvs com accountId: ' + accountId);

            }

            response = http.send(request);

            System.debug('Response Status Code: ' + response.getStatusCode());
            

            if (response.getStatusCode() == 200 || response.getStatusCode() == 201 || response.getStatusCode() == 204) {
                TriggerContext.isExecutingIntegration = true;

                if (isUpdate) {
                    account.IntegracaoTotvs__c = true;
                    account.TotvsIntegrationDetails__c = '';
                    update account;
                    System.debug('Dados atualizados com sucesso na Totvs (PUT).');
                } else {
                    Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    Integer customerCodeInt = (Integer) responseMap.get('customerCode');
                    String customerCode = String.valueOf(customerCodeInt);
                    System.debug('Customer Code recebido: ' + customerCode);account.IntegracaoTotvs__c = true;
                   
                    account.IntegracaoTotvs__c = true;
                    account.Codigo_do_cliente__c = customerCode;
                    account.TotvsIntegrationDetails__c = '';
                    update account; 
                }
                TriggerContext.isExecutingIntegration = false;
            } else {
                handleRetry(JSON.serialize(requestBodyJson), response.getBody());
            }

        } catch (Exception e) {
            System.debug('Erro na integração: ' + e.getMessage());
            handleRetry(null, e.getMessage());
        }
    }

    // Método para tratar as tentativas de re-execução
    private void handleRetry(String requestBody, String responseBody) {

        try{
            if (retryCount < TotvsIntegrationScheduler.MAX_RETRY_COUNT) {
                retryCount++;
                System.debug('Reagendando nova tentativa de integração. Tentativa número: ' + retryCount);
                System.debug('Request Body: ' + requestBody);
                System.debug('Response Body: ' + responseBody);

                if(!Test.isRunningTest()) {
                    System.enqueueJob(new TotvsIntegrationQueueable(accountId, retryCount, isUpdate));
                } else {
                    System.debug('Em contexto de teste não haverá enfileiramento.');
                }
            } else {
                System.debug('Número máximo de tentativas foi alcançado.');
                CreateLogRecord.createLog(accountId, requestBody, responseBody);
                System.debug('responseBody>> ' + responseBody);
                if(!String.isBlank(responseBody)) {
                    Map<String, Object> errorResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                    String detailedMessage = (String) errorResponse.get('detailedMessage');
                    TriggerContext.isExecutingIntegration = true;
                    Account conta = [SELECT Id, TotvsIntegrationDetails__c FROM Account WHERE Id = :accountId];
                    if (conta != null && (conta.TotvsIntegrationDetails__c == null || conta.TotvsIntegrationDetails__c != detailedMessage)) {
                        
                        conta.TotvsIntegrationDetails__c = detailedMessage;
                        update conta;
                        TriggerContext.isExecutingIntegration = false;
                    }
                }
            }
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Exception>> e.getMessage: ' + e.getMessage());
            System.debug(LoggingLevel.ERROR, 'Exception>> e.getCause: ' + e.getCause());
            System.debug(LoggingLevel.ERROR, 'Exception>> e.getLineNumber: ' + e.getLineNumber());
            System.debug(LoggingLevel.ERROR, 'Exception>> e.getStackTraceString: ' + e.getStackTraceString());
        }
    }
}