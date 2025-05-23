public with sharing class ApprovalCommentFetcher {
    public class OpportunityInput {
        @InvocableVariable(required=true)
        public Id OpportunityId;
    }

    public class Output {
        @InvocableVariable public String Comment;
        @InvocableVariable public Id AccountId;
    }

    @InvocableMethod(label='Get Approval Comment')
    public static List<Output> fetchComments(List<OpportunityInput> inputs) {

        List<Id> oppIds = new List<Id>();
        for(OpportunityInput input : inputs) {
            oppIds.add(input.OpportunityId);
        }

        Map<Id, Opportunity> opps = new Map<Id, Opportunity>([SELECT Id, AccountId FROM Opportunity WHERE Id IN :oppIds]);

        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opp : opps.values()) {
            if(opp.AccountId != null) accountIds.add(opp.AccountId);
        }

        Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id, HistoricoAprovacaoFinanceiro__c FROM Account WHERE Id IN :accountIds]);

        List<Output> results = new List<Output>();

        for(OpportunityInput input : inputs) {
            String comment = '';
            List<ProcessInstanceStep> steps = [SELECT Comments FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId =: input.OpportunityId AND Comments != '' ORDER BY CreatedDate DESC LIMIT 1];

            if(!steps.isEmpty()) {
                comment = steps[0].Comments;
            }

            Opportunity opp = opps.get(input.OpportunityId);
            String oldComment = accounts.get(opp.AccountId).HistoricoAprovacaoFinanceiro__c;

            String newComment = '[' + Datetime.now().format('dd/MM/yyyy HH:mm') + '] ' + comment;

            if(String.isNotBlank(oldComment)) {
                newComment = oldComment + '\n' + newComment;
            }

            Output output = new Output();
            output.Comment = newComment;
            output.AccountId = opps.get(input.OpportunityId).AccountId;
            results.add(output);
        }

        return results;

    }
}