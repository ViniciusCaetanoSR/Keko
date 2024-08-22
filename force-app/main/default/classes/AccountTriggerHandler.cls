public with sharing class AccountTriggerHandler {

    public static Boolean bypassTrigger = false;

    public static void onAfterInsert(List<Account> contas) {    

        bypassTrigger = true;

        for(Account conta : contas) {
            IntegrationTotvsService.enviarDadosTotvs(conta.Id);
        }
        
        bypassTrigger = false;
    }

    public static void onAfterUpdate(List<Account> updatedAccount, Map<Id, Account> oldAccounts) {

        if (!bypassTrigger) {
            IntegrationTotvsService.updateTotvs(updatedAccount);
        }
    }
}
