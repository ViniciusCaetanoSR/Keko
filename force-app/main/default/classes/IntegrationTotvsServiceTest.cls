@isTest
private class IntegrationTotvsServiceTest {

    @isTest
    static void testInsertTotvs() {
        Account testAccount = new Account(
            NomeAbreviado__c= 'KE',
            Name = 'KE',
            BillingCity = 'São Paulo',
            BillingCountry = 'Brasil',
            BillingState = 'SP',
            BillingPostalCode = '01234567',
            email_comercial__c = 'teste@exemplo.com',
            RazaoSocial__c = 'Razão Social Teste',
            Telefone_fixo__c = '1122334455',
            Phone = '1122334455',
            BillingStreet = 'Rua Teste, 123',
            Ramo_de_Atividade__c = 'Lojista',
            email_DANFE_xml__c = 'teste@danfe.com',
            Neighborhood__c = 'Centro',
            MunicipalRegistration__c = '12345678',
            Bandeira__c = 'KEKO',
            Cod_Canal__c = '2',
            Canal__c = 'AFTER MI',
            Segmento__c = 'After Nacional',
            Condicoes_de_Pagamento__c = 'Apresentação',
            CNPJ__c = '12345678000195',
            Mercado__c = 'Varejo',
            Compra_mensal_pretendida_na_abertura_da__c = 2000,
            Nome_do_contato_principal__c = 'Contato principal',
            Valor_pretendido_do_primeiro_pedido__c = 250,
            email_financeiro__c = 'teste@exemplo.com'
        );
        insert testAccount;

        List<CronTrigger> oldJobs = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name LIKE 'Integração Conta > TOTVS: %' LIMIT 1];
        if (!oldJobs.isEmpty()) {
            for (CronTrigger oldJob : oldJobs) {
                System.abortJob(oldJob.Id);
            }
        }

        Account acc = [SELECT Id FROM Account WHERE Name = 'KE' LIMIT 1];
        
        Test.startTest();
        
        IntegrationTotvsService.insertTotvs(acc);
        
        List<CronTrigger> scheduledJobs = [SELECT Id, CronExpression FROM CronTrigger];
        System.assertNotEquals(0, scheduledJobs.size(), 'O job de agendamento deve ter sido adicionado.');

        Test.stopTest();
    }

    @isTest
    static void testUpdateTotvs() {
        Account testAccount = new Account(
            NomeAbreviado__c= 'KE',
            Name = 'KE',
            BillingCity = 'São Paulo',
            BillingCountry = 'Brasil',
            BillingState = 'SP',
            BillingPostalCode = '01234567',
            email_comercial__c = 'teste@exemplo.com',
            RazaoSocial__c = 'Razão Social Teste',
            Telefone_fixo__c = '1122334455',
            Phone = '1122334455',
            BillingStreet = 'Rua Teste, 123',
            Ramo_de_Atividade__c = 'Lojista',
            email_DANFE_xml__c = 'teste@danfe.com',
            Neighborhood__c = 'Centro',
            MunicipalRegistration__c = '12345678',
            Bandeira__c = 'KEKO',
            Cod_Canal__c = '2',
            Canal__c = 'AFTER MI',
            Segmento__c = 'After Nacional',
            Condicoes_de_Pagamento__c = 'Apresentação',
            CNPJ__c = '12345678000195',
            Mercado__c = 'Varejo',
            Compra_mensal_pretendida_na_abertura_da__c = 2000,
            Nome_do_contato_principal__c = 'Contato principal',
            Valor_pretendido_do_primeiro_pedido__c = 250,
            email_financeiro__c = 'teste@teste.com'
        );
        insert testAccount;
        
        testAccount.Name = 'Conta Atualizada';

        List<CronTrigger> oldJobs = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name LIKE 'Integração Conta > TOTVS: %' LIMIT 1];
        if (!oldJobs.isEmpty()) {
            for (CronTrigger oldJob : oldJobs) {
                System.abortJob(oldJob.Id);
            }
        }
        
        Test.startTest();
        
        IntegrationTotvsService.updateTotvs(testAccount, testAccount);
        
        List<CronTrigger> scheduledJobs = [SELECT Id, CronExpression FROM CronTrigger];
        System.assertNotEquals(0, scheduledJobs.size(), 'O job de agendamento deve ter sido adicionado.');

        Test.stopTest();
    }

}