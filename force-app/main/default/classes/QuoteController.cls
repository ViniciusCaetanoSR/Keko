public without sharing class QuoteController {
    public Id cotacaoId {get; set;}
 
    public QuoteController() {
        cotacaoId = ApexPages.currentPage().getParameters().get('id');
    }

    public PageReference aprovar() {
        System.debug('cotacaoId: ' + cotacaoId);
        Quote cotacao = [SELECT Id, Status FROM Quote WHERE Id = :cotacaoId LIMIT 1];
        
        if(cotacao != null){
            cotacao.Status = 'Aprovado';
            update cotacao;

            return redirecionarPagina('Cotação aprovada com sucesso!', cotacaoId);
        }

        return null;
    }

    public PageReference reprovar() {

        Quote cotacao = [SELECT Id, Status FROM Quote WHERE Id = :cotacaoId LIMIT 1];
        
        if(cotacao != null) {
            cotacao.Status = 'Reprovado';
            update cotacao;

            return redirecionarPagina('Cotação reprovada com sucesso!', cotacaoId);
        }

        return null;
    }

    public PageReference alteracao() {
        
        System.debug('ATUALIZAÇÃO - INÍCIO DO MÉTODO ALTERACAO()');

        Quote cotacao = [SELECT Id, Status, Substatus__c FROM Quote WHERE Id = :cotacaoId LIMIT 1];

        if(cotacao != null) {
            System.debug('Substatus atual: ' + cotacao.Substatus__c);
            cotacao.Substatus__c = 'Cliente solicitou reajuste';
            update cotacao;

            System.debug('Cotação atualizada. Novo substatus: ' + cotacao.Substatus__c);

            return redirecionarPagina('Cotação reajustada com sucesso!', cotacaoId);
            
        } else {
            System.debug('COTAÇÃO NÃO ENCONTRADA');
        }

        return null;
    }

    private PageReference redirecionarPagina(String mensagem, Id idRegistro) {
        PageReference pageRef = Page.QuoteConfirmationAction;
        pageRef.getParameters().put('id', String.valueOf(idRegistro));
        pageRef.getParameters().put('msg', mensagem);
        pageRef.setRedirect(true);
        return pageRef;
    }
}