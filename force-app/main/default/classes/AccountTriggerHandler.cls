public with sharing class AccountTriggerHandler {

    public static void handleTrigger(List<Account> newAccounts) {
        
        for (Account acc : newAccounts) {
            AccountHelper.validateAndFormatPhone(acc);
        }
    }

    public static void onAfterInsert(List<Account> newAccounts) {   

        for(Account Account : newAccounts) {
           IntegrationTotvsService.insertTotvs(Account);
        }
    }

    public static void onAfterUpdate(List<Account> newAccounts, Map<Id, Account> oldAccounts) {
		
        for(Account account : newAccounts) { 

            Account oldAccount = oldAccounts.get(account.Id);

            if(String.isNotBlank(oldAccount.Codigo_do_cliente__c) && (account.Codigo_do_cliente__c == oldAccount.Codigo_do_cliente__c)){ 
                IntegrationTotvsService.updateTotvs(account);
            }
            
            if(String.isBlank(account.Codigo_do_cliente__c)) {
                IntegrationTotvsService.insertTotvs(account);
            }
        }
    }
}