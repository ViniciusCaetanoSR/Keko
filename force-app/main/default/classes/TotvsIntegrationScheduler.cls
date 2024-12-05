global class TotvsIntegrationScheduler implements Schedulable {

    global String idConta;
    global Integer retryCount;
    global Boolean isUpdate;
    global static final Integer MAX_RETRY_COUNT = 3;

    public TotvsIntegrationScheduler(String idConta, Integer retryCount, Boolean isUpdate) {
        this.idConta = idConta;
        this.retryCount = retryCount;
        this.isUpdate = isUpdate;
    }

    // Método para agendar a primeira tentativa de integração
    public static void scheduleAttempt(String idConta, Boolean isUpdate) {
        
        // Gera a expressão cron para a primeira execução em 1 minuto
        String cronExp = generateCronExpression(1);
        Long uniqueSuffix = System.currentTimeMillis();
        String jobName = 'Integração Conta > TOTVS: ' + idConta + ' |' + uniqueSuffix + '|';
        TotvsIntegrationScheduler job = new TotvsIntegrationScheduler(idConta, 0, isUpdate); 
        System.schedule(jobName, cronExp, job);
        System.debug('Job de integração inicial agendado com nome: ' + jobName);
        
        //Account account = [SELECT Id, TotvsIntegrationDetails__c FROM Account WHERE Id = :idConta LIMIT 1];

      //if (account != null) {
       //  account.TotvsIntegrationDetails__c = 'Integração em processo';
       //  update account;
      //}
    }

    global void execute(SchedulableContext sc) {
        System.debug('Agendando integração com Totvs usando Queueable.');
        System.enqueueJob(new TotvsIntegrationQueueable(idConta, retryCount, isUpdate));
    }

    public static String generateCronExpression(Integer minutes) {
        Datetime dt = System.now().addMinutes(minutes);
        return '0 ' + dt.minute() + ' ' + dt.hour() + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
    }
}