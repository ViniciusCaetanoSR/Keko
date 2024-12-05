@isTest
private class TotvsIntegrationQueueableTest {
    
    @TestSetup
    static void setupTestData() {

        Account acc = new Account(
            NomeAbreviado__c = 'T-01',
            Name = 'Teste 01',
            RazaoSocial__c = 'Teste 01 Inc.',
            Ramo_de_Atividade__c = 'Lojista',
            BillingStreet = 'Rua Teste, 152',
            BillingCity = 'Teste City',
            BillingCountry = 'Brasil',
            BillingState = 'SP',
            BillingPostalCode = '1234-5678',
            email_comercial__c = 'email@email.com',
            email_DANFE_xml__c = 'teste@danfe.com',
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
            MunicipalRegistration__c = '12345678',
            Codigo_do_cliente__c = '12345',
            Compra_mensal_pretendida_na_abertura_da__c = 2000,
            Nome_do_contato_principal__c = 'Contato principal',
            Valor_pretendido_do_primeiro_pedido__c = 250,
            email_financeiro__c = 'teste@teste.com'

        );
        insert acc;

        TotvsAPI__c totvsApi = new TotvsAPI__c();
        totvsApi.Name = 'accesses';
        totvsApi.username__c = 'usuario_teste';
        totvsApi.password__c = 'senha_teste';
        totvsApi.base_URL__c = 'https://api.totvs.com/v1/clientes';
        totvsApi.DefaultHolder__c = 1;
        totvsApi.DefaultModality__c = 2;
        totvsApi.EntityType__c = 3;
        totvsApi.IbgeCode__c = 4;
        totvsApi.Modality__c = 5;
        insert totvsApi;
    }

    @isTest
    static void testPostIntegration() {
        Account account = [SELECT Id FROM Account LIMIT 1];

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(true));

        Test.startTest();
        TotvsIntegrationQueueable queueableJob = new TotvsIntegrationQueueable(account.Id, 0, false);
        System.enqueueJob(queueableJob);
        Test.stopTest();

        Account updatedAcc = [SELECT Codigo_do_cliente__c, IntegracaoTotvs__c FROM Account WHERE Id = :account.Id];
        System.assertEquals('12345', updatedAcc.Codigo_do_cliente__c);
        System.assertEquals(true, updatedAcc.IntegracaoTotvs__c);
    }

    @isTest
    static void testPutIntegration() {
        Account account = [SELECT Id, Codigo_do_cliente__c FROM Account WHERE Codigo_do_cliente__c != null LIMIT 1];

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(false));

        Test.startTest();
        TotvsIntegrationQueueable queueableJob = new TotvsIntegrationQueueable(account.Id, 0, true);
        System.enqueueJob(queueableJob);
        Test.stopTest();

        Account updatedAcc = [SELECT Codigo_do_cliente__c, IntegracaoTotvs__c FROM Account WHERE Id = :account.Id];
        System.assertEquals('12345', updatedAcc.Codigo_do_cliente__c);
    }

    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private Boolean isPost;

        public MockHttpResponseGenerator(Boolean isPost) {
            this.isPost = isPost;
        }

        public HttpResponse respond(HttpRequest req) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');

            if (isPost) {
                response.setBody('{"customerCode": 12345}');
                response.setStatusCode(201);
            } else {
                response.setBody('{"status":"success"}');
                response.setStatusCode(200);
            }
            return response;
        }
    }
}