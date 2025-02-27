@isTest
private class DeleteRecordsBatchTest {
    
    @testSetup
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
    }

    @isTest
    static void testDeleteRecordsBatch() {
        String query = 'SELECT Id FROM Account WHERE Name LIKE \'Teste 01%\'';

        Test.startTest();
        DeleteRecordsBatch batch = new DeleteRecordsBatch(query);
        Database.executeBatch(batch);
        Test.stopTest();

        Integer count = [SELECT COUNT() FROM Account WHERE Name LIKE 'Teste 01%'];
        System.assertEquals(0, count, 'Os registros devem ter sido excluídos.');
    }
}
