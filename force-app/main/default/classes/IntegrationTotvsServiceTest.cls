@isTest
private class IntegrationTotvsServiceTest {

    @isTest
    static void testEnviarDadosTotvs() {
        Account testAccount = new Account(
            Name = 'Test Account',
            RazaoSocial__c = 'Test Razão Social',
            Ramo_de_Atividade__c = 'Distribuidor');
        insert testAccount;

        TotvsAPI__c testTotvsApi = new TotvsAPI__c(
            Name = 'accesses',
            base_URL__c = 'https://api.totvs.com/endpoint',
            username__c = 'testuser',
            password__c = 'testpassword'
        );
        insert testTotvsApi;

        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        IntegrationTotvsService.enviarDadosTotvs(testAccount.Id);
        Test.stopTest();
    }

    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"status":"success"}');
            response.setStatusCode(200);
            return response;
        }
    }
}