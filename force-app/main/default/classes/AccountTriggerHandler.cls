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

		if (!TriggerContext.isExecutingIntegration) {
            
            for(Account newAccount : newAccounts) { 

                Account oldAccount = oldAccounts.get(newAccount.Id);

                if(String.isNotBlank(oldAccount.Codigo_do_cliente__c) && (newAccount.Codigo_do_cliente__c == oldAccount.Codigo_do_cliente__c)){ 
                    IntegrationTotvsService.updateTotvs(newAccount, oldAccount);
                }
                
                if(String.isBlank(newAccount.Codigo_do_cliente__c)) {
                    IntegrationTotvsService.insertTotvs(newAccount);
                }
            }
        }   
    }
}