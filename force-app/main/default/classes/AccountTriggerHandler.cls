public with sharing class AccountTriggerHandler {
    public static void handleTrigger(List<Account> newAccounts) {
        for (Account acc : newAccounts) {
            AccountHelper.validateAndFormatPhone(acc);
        }
    }
}