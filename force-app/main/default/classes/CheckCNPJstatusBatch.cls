public with sharing class CheckCNPJstatusBatch implements Database.Batchable <SObject>, Database.AllowsCallouts {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String QUERY =
            'SELECT Id, Name, CNPJ__c, Situacao__c FROM Account WHERE CNPJ__c != null';
            System.debug('QUERY : '+QUERY);

        return Database.getQueryLocator(QUERY);
    }

    public void execute(Database.BatchableContext bc, List<Account> accounts) {
        System.debug('teste accounts : '+accounts);
        List<Account> accToUpdate = new List<Account>();

        for (Account acc : accounts) {
            CheckCNPJstatusResponse response = validateStatus(acc.cnpj__c);
            System.debug('nome: '+acc.Name+' - status: '+response.situacao);
            if (response.situacao == 'BAIXADA' && acc.Situacao__c != 'BAIXADA') {
                acc.Situacao__c = response.situacao;
                accToUpdate.add(acc);
            }
        }
        if (!accToUpdate.isEmpty()) {
            update accToUpdate;
        }
        
    }

    public void finish(Database.BatchableContext bc) {
    }

    public CheckCNPJstatusResponse validateStatus (String cnpj) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://brasilapi.com.br/api/cnpj/v1/' + cnpj);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setTimeout(120000);

        try {
            Http h = new Http();
            HttpResponse res = h.send(req);            
            if (res.getStatusCode() == 200) {
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                CheckCNPJstatusResponse informacoesCNPJ = new CheckCNPJstatusResponse();
                informacoesCNPJ.situacao = (String) jsonResponse.get('descricao_situacao_cadastral');
                
                return informacoesCNPJ;
            }
        } catch (Exception e) {
            return null;
        }

        return null;
    }
}