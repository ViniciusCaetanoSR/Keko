global class DeleteRecordsBatch implements Database.Batchable<sObject> {
    
    private String query;
    
    global DeleteRecordsBatch(String query) {
        this.query = query;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope) {
        try {
            if (!scope.isEmpty()) {
                delete scope;
                System.debug('Lote de ' + scope.size() + ' registros excluído com sucesso.');
            }
        } catch (Exception e) {
            System.debug('Erro ao excluir lote: ' + e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems 
                           FROM AsyncApexJob 
                           WHERE Id = :bc.getJobId()];
        System.debug('Batch concluído. Status: ' + job.Status);
        System.debug('Total de lotes processados: ' + job.TotalJobItems);
        System.debug('Erros encontrados: ' + job.NumberOfErrors);
    }
}