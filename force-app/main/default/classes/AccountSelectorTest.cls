@isTest
private class AccountSelectorTest {

    @isTest(SeeAllData=true)
    static void testAccountSelector() {
        
        Account testAccount = new Account(
            NomeAbreviado__c = 'T1234',
            Name = 'L-Teste',
            Phone = '+55(11)98765-4321',
            Neighborhood__c = 'Bairro Teste',
            MunicipalRegistration__c = '123456789',
            RazaoSocial__c = 'Razao Social Teste',
            email_comercial__c = 'teste@teste.com',
            BillingStreet = 'Rua Teste, 152',
            BillingCity = 'Cidade Teste',
            BillingState = 'SP',
            BillingPostalCode = '12345-678',
            BillingCountry = 'BRASIL',
            Telefone_fixo__c = '+55(11)98765-4321',
            Ramo_de_Atividade__c = 'Lojista',
            email_DANFE_xml__c = 'danfe@teste.com',
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

        Account account = [SELECT Id FROM Account WHERE Name = 'L-Teste' LIMIT 1];
		
        Test.startTest();
        Account result = AccountSelector.selectAccountById(account.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'A conta não deve ser nula');
        System.assertEquals(account.Id, result.Id, 'O ID da conta retornada deve ser igual ao ID da conta criada');
        System.assertEquals('T1234', result.NomeAbreviado__c, 'O nome abreviado da conta retornada deve ser igual ao nome abreviado da conta criada');
        System.assertEquals('L-Teste', result.Name, 'O nome da conta deve ser "L-Teste"');
        System.assertEquals('+55(11)98765-4321', result.Phone, 'O telefone da conta deve ser "+55(11)98765-4321"');
        System.assertEquals('Bairro Teste', result.Neighborhood__c, 'O bairro da conta deve ser "Bairro Teste"');
        System.assertEquals('123456789', result.MunicipalRegistration__c, 'A inscrição municipal deve ser "123456789"');
        System.assertEquals('Razao Social Teste', result.RazaoSocial__c, 'A razão social deve ser "Razao Social Teste"');
        System.assertEquals('teste@teste.com', result.email_comercial__c, 'O email comercial deve ser "teste@teste.com"');
        System.assertEquals('Rua Teste, 152', result.BillingStreet, 'A rua de cobrança deve ser "Rua Teste, 152"');
        System.assertEquals('Cidade Teste', result.BillingCity, 'A cidade de cobrança deve ser "Cidade Teste"');
        System.assertEquals('SP', result.BillingState, 'O estado de cobrança deve ser "SP"');
        System.assertEquals('12345-678', result.BillingPostalCode, 'O código postal de cobrança deve ser "12345-678"');
        System.assertEquals('BRASIL', result.BillingCountry, 'O país de cobrança deve ser "BRASIL"');
        System.assertEquals('+55(11)98765-4321', result.Telefone_fixo__c, 'O telefone fixo deve ser "+55(11)98765-4321"');
        System.assertEquals('Lojista', result.Ramo_de_Atividade__c, 'O ramo de atividade deve ser "Lojista"');
        System.assertEquals('danfe@teste.com', result.email_DANFE_xml__c, 'O email para DANFE/XML deve ser "danfe@teste.com"');
    }
}