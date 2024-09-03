@isTest
private class CreateLogRecordTest {

    @isTest
    static void testCreateLogSuccess() {

        String idConta = '12345678ABCD';
        String requestBodyJson = '{"key":"value"}';
        String errorMessage = 'Teste de mensagem de erro';

        Test.startTest();
        CreateLogRecord.createLog(idConta, requestBodyJson, errorMessage);
        Test.stopTest();

        Log__c[] log = [SELECT Id, ErrorMessage__c, Conta__c, Request__c FROM Log__c LIMIT 1];
        
        if(log.size() > 0) {
         	System.assertEquals('Teste de mensagem de erro', log[0].ErrorMessage__c, 'A mensagem de erro não está correta.');
        	System.assertEquals('12345678', log[0].Conta__c, 'O ID da conta não está correto.');
        	System.assertEquals('{"key":"value"}', log[0].Request__c, 'O JSON da requisição não está correto.');   
        }
    }
}