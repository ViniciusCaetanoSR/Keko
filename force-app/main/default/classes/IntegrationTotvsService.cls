public with sharing class IntegrationTotvsService {

    private static final String TOTVS_SETTING_NAME = 'Totvs';
    private static BypassSettings__mdt bypassSettings;

    /**
     * Envia os dados de uma Account para inserção no TOTVS.
     * @param account A conta a ser enviada para integração.
     */
    public static void insertTotvs(Account account) {
        System.debug('Iniciando envio de dados para TOTVS (INSERT) para a conta: ' + account.Id);

        if (!isIntegrationBypassed()) {
            try {
                TotvsIntegrationScheduler.scheduleAttempt(account.Id, false);
            } catch (Exception e) {
                System.debug('Erro ao agendar inserção no TOTVS: ' + e.getMessage());
            }
        }
    }

    /**
     * Envia os dados de uma Account para atualização no TOTVS.
     * @param account A conta a ser enviada para integração.
     */
    public static void updateTotvs(Account account, Account oldAccount) {
        System.debug('Iniciando envio de dados para TOTVS (UPDATE) para a conta: ' + account.Id);

        if (!isIntegrationBypassed()) {
            try {
                TotvsIntegrationScheduler.scheduleAttempt(account.Id, true);
            } catch (Exception e) {
                System.debug('Erro ao agendar atualização no TOTVS: ' + e.getMessage());
            }
        }
    }

    /**
     * Verifica se a integração com o TOTVS deve ser ignorada com base nas configurações.
     * @return true se a integração deve ser bypassed, false caso contrário.
     */
    private static Boolean isIntegrationBypassed() {
        // Carrega as configurações apenas uma vez (lazy loading)
        if (bypassSettings == null) {
            try {
                bypassSettings = [SELECT BypassIntegration__c 
                                 FROM BypassSettings__mdt 
                                 WHERE DeveloperName = :TOTVS_SETTING_NAME 
                                 LIMIT 1];
            } catch (QueryException e) {
                System.debug('Configuração BypassSettings__mdt não encontrada para ' + TOTVS_SETTING_NAME + '. Erro: ' + e.getMessage());
                return false;
            }
        }
        return bypassSettings != null && bypassSettings.BypassIntegration__c;
    }
}