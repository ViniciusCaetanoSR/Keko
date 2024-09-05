@isTest
private class TotvsBodyMapperTest {
    
    @isTest(SeeAllData=true)
    private static void testTotvsMapper() {

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
            Mercado__c = 'Varejo');
        insert testAccount;
        
        Bandeira__mdt testBandeira = new Bandeira__mdt(
            MasterLabel = 'Keko',
            CustomerGroup__c = 1,
            RepresentativeCode__c = 100
        );

        PaymentCondition__mdt testPaymentCondition = new PaymentCondition__mdt(
            MasterLabel = '30 Dias',
            PaymentTerms__c = 30
        );
        System.debug('PC: ' + testPaymentCondition);
        System.debug('Test Account' + testAccount);
        
        Test.startTest();
        TotvsBody request = TotvsBodyMapper.totvsMapper(testAccount);
		
        System.debug('TEEEEST: ' + request);
        
        System.assertNotEquals(null, 'O request não pode ser null.');
        System.assertEquals('KE', request.shortName, 'O shortName deve ser "KE"');
        System.assertEquals('São Paulo', request.city, 'A city deve ser "São Paulo"');
        System.assertEquals('Brasil', request.country, 'O country deve ser "Brasil"');
        System.assertEquals('SP', request.billingState, 'O billingState deve ser "SP"');
        System.assertEquals('01234567', request.billingZipCode, 'O billingZipCode deve ser "01234567"');
        System.assertEquals('teste@exemplo.com', request.email, 'O email deve ser "teste@exemplo.com"');
        System.assertEquals('Razão Social Teste', request.customerName, 'O customerName deve ser "Razão Social Teste"');
        System.assertEquals('12345678000195', request.personalId, 'O personalId deve ser "12345678000195"');
        System.assertEquals('1122334455', request.phone1, 'O phone1 deve ser "1122334455"');
        System.assertEquals('Rua Teste, 123', request.billingCompleteAddress, 'O billingCompleteAddress deve ser "Rua Teste, 123"');
        System.assertEquals('Lojista', request.activityBranch, 'O activityBranch deve ser "Lojista"');
        System.assertEquals(1, request.customerGroup, 'O customerGroup deve ser 1');
        System.assertEquals(100, request.representativeCode, 'O representativeCode deve ser 100');
        System.assertEquals('teste@danfe.com', request.NFeEmail, 'O NFeEmail deve ser "teste@danfe.com"');
        System.assertEquals('KE', request.tradeName, 'O tradeName deve ser "KE"');
        System.assertEquals('Centro', request.billingNeighborhood, 'O billingNeighborhood deve ser "Centro"');
        System.assertEquals('12345678', request.municipalRegistration, 'O municipalRegistration deve ser "12345678"');
        System.assertEquals(9999, request.defaultHolder, 'O defaultHolder deve ser 9999');
        System.assertEquals(6, request.defaultModality, 'O defaultModality deve ser 6');
        System.assertEquals(2, request.entityType, 'O entityType deve ser 2');
        System.assertEquals(6, request.modality, 'O modality deve ser 6');
        System.assertEquals('Centro', request.neighborhood, 'O neighborhood deve ser "Centro"');
        System.assertEquals(0, request.billingIbgeCode, 'O billingIbgeCode deve ser 0');
        //System.assertEquals(2110, request.paymentTerms, 'O paymentTerm deve ser 2110');
        
        Test.stopTest();
    }
    
}