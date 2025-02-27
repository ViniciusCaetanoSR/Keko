public with sharing class IntegrationTotvsService {

    public static void insertTotvs(Account account) {
        System.debug('Iniciando envio de dados para Totvs INSERT: ' + account.Id);
        TotvsIntegrationScheduler.scheduleAttempt(account.Id, false);
    }

    public static void updateTotvs(Account newAccount, Account oldAccount) {
        System.debug('Iniciando envio de dados para Totvs UPDATE: ' + account.Id);
        TotvsIntegrationScheduler.scheduleAttempt(newAccount.Id, true);
    }
}