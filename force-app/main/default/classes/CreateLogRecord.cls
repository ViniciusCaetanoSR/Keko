public with sharing class CreateLogRecord {
    public static void createLog(String idConta, String requestBodyJson, String errorMessage) {

        try{

            Log__c log = new Log__c();
            log.ErrorMessage__c = errorMessage;
            log.Conta__c = idConta;
            log.Request__c = requestBodyJson;
            insert log;
            
            System.debug('Registro de log criado com sucesso: ' + log.Id);

        } catch (Exception e) {
            System.debug('Erro ao criar registro de erro: ' + e.getMessage());
        }

    }
}