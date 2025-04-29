@IsTest 
private class QuoteControllerTest {

    private static Quote CotacaoTeste() {
        Account conta = new Account(
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

        insert conta;

        Opportunity oportunidade = new Opportunity(
            Name = 'Oportunidade Teste',
            StageName = 'Novo',
            CloseDate = Date.today(),
            AccountId = conta.Id
        );
        
        insert oportunidade;

        Quote qt = new Quote(
            Name = 'QT Teste',
            OpportunityId = oportunidade.Id,
            Status= '',
            Substatus__c = '',
            JustificativaDoReajuste__c = ''
        );

        insert qt;

        return qt;
    }

    @IsTest
    static void testAprovado() {

        Quote cotacao = CotacaoTeste();
        
        ApexPages.currentPage().getParameters().put('id', cotacao.Id);

        Test.startTest();
            QuoteController controller = new QuoteController();
            controller.aprovar();
        Test.stopTest();

        Quote cotacaoAtualizada = [SELECT Id, Status FROM Quote WHERE Id = :cotacao.Id LIMIT 1];
        System.assertEquals('Aprovado', cotacaoAtualizada.Status);
    }

    @IsTest
    static void testReprovado() {

        Quote cotacao = CotacaoTeste();
        
        ApexPages.currentPage().getParameters().put('id', cotacao.Id);

        Test.startTest();
            QuoteController controller = new QuoteController();
            controller.reprovar();
        Test.stopTest();

        
        Quote cotacaoAtualizada = [SELECT Id, Substatus__c FROM Quote WHERE Id = :cotacao.Id LIMIT 1];
        System.assertEquals('Cotação reprovada pelo cliente', cotacaoAtualizada.Substatus__c);
    }

    @IsTest
    static void testAlteracao() {
        
        Quote cotacao = CotacaoTeste();
        ApexPages.currentPage().getParameters().put('id', cotacao.Id);

        Test.startTest();
            QuoteController controller = new QuoteController();
            controller.justificativa = 'Preço alto demais. Ciente quer negociar.';
            controller.alteracao();
        Test.stopTest();

        Quote cotacaoAtualizada = [SELECT Id, Substatus__c, JustificativaDoReajuste__c FROM Quote WHERE Id = :cotacao.Id LIMIT 1];
        System.assertEquals('Cliente solicitou reajuste', cotacaoAtualizada.Substatus__c);
        System.assertEquals('Preço alto demais. Ciente quer negociar.', cotacaoAtualizada.JustificativaDoReajuste__c);
    }

}


