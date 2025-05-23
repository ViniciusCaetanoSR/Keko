@isTest
private class TOTVSQOPServiceTest {

    @TestSetup
    static void makeData(){
        Account account = new Account(
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

        insert account;

        Opportunity opportunity = new Opportunity(
            Name = 'Oportunidade Teste',
            StageName = 'Teste',
            CloseDate = Date.today(),
            AccountId = account.Id
        );

        insert opportunity;

        Product2 product = new Product2(
            Name = 'Produto Teste',
            ProductCode = 'P001',
            IsActive = true
        );

        insert product;

        Id standardPricebookId = Test.getStandardPricebookId();
    
        PricebookEntry standardEntry = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = product.Id,
            UnitPrice = 50,
            IsActive = true
        );

        insert standardEntry;

        Pricebook2 customPricebook = new Pricebook2(
            Name = 'Tabela Teste',
            PriceBookCode__c = '0022412B',
            IsActive = true
        );

        insert customPricebook;

        PricebookEntry customEntry = new PricebookEntry(
            Pricebook2Id = customPricebook.Id,
            Product2Id = product.Id,
            UnitPrice = 50,
            IsActive = true
        );

        insert customEntry;

        Quote quote = new Quote(
            Name = 'Cotação Teste',
            Pricebook2Id = customPricebook.Id,
            CondicoesPagamento__c = 'Apresentação',
            OpportunityId = opportunity.Id
        );

        insert quote;
        
        QuoteLineItem item = new QuoteLineItem(
            QuoteId = quote.Id,
            PricebookEntryId = customEntry.Id,
            Quantity = 1,
            UnitPrice = 50
        );

        insert item;
    }

    private class TOTVSQOPMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "success": true, "message": "OK" }');
            res.setStatusCode(200);
            return res;
        }
    }


    @isTest
    static void testSendQuote() {

        Quote quote = [SELECT Id FROM Quote LIMIT 1];

        Test.setMock(HttpCalloutMock.class, new TOTVSQOPMock());

        Test.startTest();
        TOTVSQOPService.sendQuote(quote.Id);
        Test.stopTest();

        List<Integration_Log__c> logs = [SELECT Id FROM Integration_Log__c WHERE Quote__c = :quote.Id];
        System.assertEquals(0, logs.size(), 'Não deve ter log de erro.');
    }

    @isTest
    static void testSimulateQuote() {
        TOTVSQuoteDTO dto = new TOTVSQuoteDTO();
        dto.branchId = '20';
        dto.cifCity = 'Destino';
        dto.codeCarrier = 92;
        dto.customerCoder = 569;
        dto.deliveryCode = 'Padrão';
        dto.customerDiscount = 10;
        dto.paymentTerms = 130;
        dto.percentageFreight = 0;
        dto.priceTableQuote = '0022412B';
        dto.salesChannel = 2;
        dto.operationTypeCode = 1;
        dto.priceQuoteType = 2;
        dto.useDiscountTable = true;
        dto.shortName = 'Auto K';
        dto.transactionType = '511021';
        dto.valueFreight = 0;
        dto.addItem('P001', '0022412', 1);

        Test.setMock(HttpCalloutMock.class, new TOTVSQOPMock());

        Test.startTest();
        String result = TOTVSQOPService.simulateQuote(dto);
        Test.stopTest();

        System.assert(result.contains('success'), 'Resposta deve conter sucesso');
    }
}