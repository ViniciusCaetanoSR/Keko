public with sharing class AccountTriggerHandler {

    public static void handleTrigger(List<Account> newAccounts) {
        
        for (Account acc : newAccounts) {
            AccountHelper.validateAndFormatPhone(acc);
        }
    }

    public static void onAfterInsert(List<Account> contas) {    

        for(Account conta : contas) {
            IntegrationTotvsService.enviarDadosTotvs(conta.Id);
        }
    }

    public static void onAfterUpdate(List<Account> updatedAccount, Map<Id, Account> oldAccounts) {
		
        for(Account acc : updatedAccount) { //for temporario
            Account oldAccount = oldAccounts.get(acc.Id);
            if(acc.Codigo_do_cliente__c == oldAccount.Codigo_do_cliente__c){
                IntegrationTotvsService.updateTotvs(updatedAccount);
            }
        }
    }
}