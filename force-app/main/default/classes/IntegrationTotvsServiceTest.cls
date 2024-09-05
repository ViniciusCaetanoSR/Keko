@isTest
private class IntegrationTotvsServiceTest {

    @isTest(SeeAllData=true)
    static void testEnviarDadosTotvs() {
        Account testAccount = new Account(
            NomeAbreviado__c = 'INT',
            Name = 'INT INT',
            RazaoSocial__c = 'INT INT INC.',
            Ramo_de_Atividade__c = 'Lojista',
            BillingStreet = 'Rua Teste, 152',
            BillingCity = 'Int City',
            BillingCountry = 'Brasil',
            BillingState = 'SP',
            BillingPostalCode = '1234-5678',
            email_comercial__c = 'email@email.com',
            Telefone_fixo__c = '1111111111',
            Phone = '1111111111',
            Neighborhood__c = 'Bairro',
            Bandeira__c = 'KEKO',
            Cod_Canal__c = '2',
            Canal__c = 'AFTER MI',
            Segmento__c = 'After Nacional',
            Condicoes_de_Pagamento__c = 'Apresentação',
            CNPJ__c = '12345678000195',
            Mercado__c = 'Varejo',
            MunicipalRegistration__c = '12345678'
            );
        insert testAccount;

        TotvsAPI__c testTotvsApi = new TotvsAPI__c(
            Name = 'acc',
            base_URL__c = 'https://api.totvs.com/endpoint',
            username__c = 'testuser',
            password__c = 'testpassword',
            DefaultHolder__c = 1,
            DefaultModality__c = 2,
            EntityType__c = 3,
            Modality__c = 4,
            IbgeCode__c = 5
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