@isTest
private class AccountSelectorTest {

    @TestSetup
    static void createData() {
        Account testAccount = new Account(
            Name = 'Conta de Teste',
            Phone = '+55(11)98765-4321',
            Neighborhood__c = 'Bairro Teste',
            MunicipalRegistration__c = '123456789',
            RazaoSocial__c = 'Razao Social Teste',
            email_comercial__c = 'teste@teste.com',
            BillingStreet = 'Rua Teste',
            BillingCity = 'Cidade Teste',
            BillingState = 'Estado Teste',
            BillingPostalCode = '12345-678',
            BillingCountry = 'País Teste',
            Telefone_fixo__c = '+55(11)98765-4321',
            Ramo_de_Atividade__c = 'Lojista',
            email_DANFE_xml__c = 'danfe@teste.com'
        );
        insert testAccount;
    }

    @isTest
    static void testTotvsMapper() {
        Test.startTest();

        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        Account result = AccountSelector.selectAccountById(testAccount.Id);

        System.assertNotEquals(null, result, 'A conta não deve ser nula');
        System.assertEquals(testAccount.Id, result.Id, 'O ID da conta retornada deve ser igual ao ID da conta criada');
        System.assertEquals('Conta de Teste', result.Name, 'O nome da conta deve ser "Conta de Teste"');
        System.assertEquals('+55(11)98765-4321', result.Phone, 'O telefone da conta deve ser "+55(11)98765-4321"');
        System.assertEquals('Bairro Teste', result.Neighborhood__c, 'O bairro da conta deve ser "Bairro Teste"');
        System.assertEquals('123456789', result.MunicipalRegistration__c, 'A inscrição municipal deve ser "123456789"');
        System.assertEquals('Razao Social Teste', result.RazaoSocial__c, 'A razão social deve ser "Razao Social Teste"');
        System.assertEquals('teste@teste.com', result.email_comercial__c, 'O email comercial deve ser "teste@teste.com"');
        System.assertEquals('Rua Teste', result.BillingStreet, 'A rua de cobrança deve ser "Rua Teste"');
        System.assertEquals('Cidade Teste', result.BillingCity, 'A cidade de cobrança deve ser "Cidade Teste"');
        System.assertEquals('Estado Teste', result.BillingState, 'O estado de cobrança deve ser "Estado Teste"');
        System.assertEquals('12345-678', result.BillingPostalCode, 'O código postal de cobrança deve ser "12345-678"');
        System.assertEquals('País Teste', result.BillingCountry, 'O país de cobrança deve ser "País Teste"');
        System.assertEquals('+55(11)98765-4321', result.Telefone_fixo__c, 'O telefone fixo deve ser "+55(11)98765-4321"');
        System.assertEquals('Lojista', result.Ramo_de_Atividade__c, 'O ramo de atividade deve ser "Lojista"');
        System.assertEquals('danfe@teste.com', result.email_DANFE_xml__c, 'O email para DANFE/XML deve ser "danfe@teste.com"');

        Test.stopTest();
    }
}