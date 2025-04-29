@isTest
private class TotvsIntegrationQueueableTest {

    @TestSetup
    static void setup() {
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

    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private Integer statusCode;
        private String responseBody;

        public MockHttpResponseGenerator(Integer statusCode, String responseBody) {
            this.statusCode = statusCode;
            this.responseBody = responseBody;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(statusCode);
            res.setBody(responseBody);
            return res;
        }
    }

    @isTest
    static void testSuccessfulPostIntegration() {
     
        Account acc = [SELECT Id, Codigo_do_cliente__c FROM Account LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(201, '{"customerCode": 67890}'));

        Test.startTest();
        TotvsIntegrationQueueable job = new TotvsIntegrationQueueable(acc.Id, 0, false);
        System.enqueueJob(job);
        Test.stopTest();

        Account updatedAcc = [SELECT IntegracaoTotvs__c, Codigo_do_cliente__c, TotvsIntegrationDetails__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(true, updatedAcc.IntegracaoTotvs__c, 'A integração deveria ser marcada como concluída.');
        System.assertEquals('67890', updatedAcc.Codigo_do_cliente__c, 'O código do cliente deveria ser atualizado.');
    }

    @isTest
    static void testSuccessfulPutIntegration() {
     
        Account acc = [SELECT Id, Codigo_do_cliente__c FROM Account LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, '{}'));

        Test.startTest();
        TotvsIntegrationQueueable job = new TotvsIntegrationQueueable(acc.Id, 0, true);
        System.enqueueJob(job);
        Test.stopTest();

        Account updatedAcc = [SELECT IntegracaoTotvs__c, Codigo_do_cliente__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals('12345', updatedAcc.Codigo_do_cliente__c, 'O código do cliente não deveria mudar em um PUT.');
        System.debug('Teste de PUT concluído com sucesso.');
    }

    @isTest
    static void testRetryOnFailure() {

        Account acc = [SELECT Id FROM Account LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(500, '{"detailedMessage": "Erro interno no servidor"}'));

        Test.startTest();
        TotvsIntegrationQueueable job = new TotvsIntegrationQueueable(acc.Id, 0, false);
        job.execute(null);
        Test.stopTest();

        Account updatedAcc = [SELECT TotvsIntegrationDetails__c FROM Account WHERE Id = :acc.Id];
    }

    @isTest
    static void testMaxRetryReached() {

        Account acc = [SELECT Id FROM Account LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(400, '{"detailedMessage": "Dados inválidos"}'));

        Test.startTest();
        TotvsIntegrationQueueable job = new TotvsIntegrationQueueable(acc.Id, 1, false);
        job.execute(null);
        Test.stopTest();

        Account updatedAcc = [SELECT TotvsIntegrationDetails__c FROM Account WHERE Id = :acc.Id];
    }

    @isTest
    static void testExceptionHandling() {

        Account acc = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        TotvsIntegrationQueueable job = new TotvsIntegrationQueueable(acc.Id, 0, false);
        job.execute(null);
        Test.stopTest();

        Account updatedAcc = [SELECT TotvsIntegrationDetails__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(null, updatedAcc.TotvsIntegrationDetails__c, 'Nenhum detalhe deveria ser atualizado em caso de exceção genérica.');
    }

    @isTest
    static void testAccountNotFound() {
  
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(201, '{"customerCode": 67890}'));

        Test.startTest();
        TotvsIntegrationQueueable job = new TotvsIntegrationQueueable('001000000000000AAA', 0, false);
        job.execute(null); 
        Test.stopTest();

        List<Account> accounts = [SELECT Id FROM Account WHERE IntegracaoTotvs__c = true];
        System.assertEquals(0, accounts.size(), 'Nenhuma conta deveria ser atualizada se o ID estiver inválido.');
    }
}