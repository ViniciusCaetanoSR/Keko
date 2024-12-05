@isTest
private class TotvsIntegrationSchedulerTest {

    @isTest
    static void testScheduleAttempt() {
        String idConta = '12345678ABCD';
        Boolean isUpdate = true;

        List<CronTrigger> oldJobs = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name LIKE 'Integração Conta > TOTVS: %'];
        if (!oldJobs.isEmpty()) {
            for (CronTrigger oldJob : oldJobs) {
                System.abortJob(oldJob.Id);
            }
        }

        Test.startTest();
        TotvsIntegrationScheduler.scheduleAttempt(idConta, isUpdate);

        List<CronTrigger> triggers = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name LIKE 'Integração Conta > TOTVS: %'];
        System.assertEquals(1, triggers.size(), 'Um job de integração deve ter sido agendado.');
        System.assert(triggers[0].CronJobDetail.Name.contains(idConta), 'O nome do job deve conter o ID da conta.');
    }
}