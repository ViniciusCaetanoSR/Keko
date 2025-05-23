public with sharing class LeadCreator {
    public static void createLeads(integer amount, Boolean generateInvalidData) {
        List<Lead> newLeads = new List<Lead>();

        List<String> firstNames = new List<String>{'Antônio', 'Roberta', 'Carol', 'Fábio', 'Ricardo', 'Esther', 'Alice', 'Roberto', 'Caio', 'Fernanda', 'Deborah', 'Guilher'};
        List<String> lastNames = new List<String>{'Assunção', 'Costa', 'Souza', 'Britto', 'Moraes', 'Santos', 'Brutapi', 'Moura', 'Santana', 'Braga', 'Santos', 'Braga'};
        

        for(Integer i = 1; i <= amount; i++) {
            String firstName = firstNames[Math.mod(Math.abs(Crypto.getRandomInteger()), firstNames.size())];
            String lastName = lastNames[Math.mod(Math.abs(Crypto.getRandomInteger()), lastNames.size())];
            String numberCompany = String.valueOf(Math.mod(Math.abs(Crypto.getRandomInteger()), 10000));


            Lead lead = new Lead(
                FirstName = firstName,
                LastName = generateInvalidData ? null : lastName,
                Phone = '112345678' + i,
                Segmento__c = 'After Nacional',
                Telefone_fixo__c = '112333333' + i,
                Ramo_de_Atividade__c = 'Lojista',
                email_comercial__c = 'lead'+i+'@email.com',
                LeadSource = 'Site Keko',
                Mercado__c = 'Varejo',
                Company = 'LTDA. ' + numberCompany,
                Canal__c = 'AFTER MI',
                Cod_Canal__c = '2',
                Bandeira__c = 'KEKO',
                Cidade__c = 'a02be000001S99sAAC'
            );

            newleads.add(lead);
        }

        try {
            insert newLeads;
            System.debug('Leads inseridos com sucesso no sistema de desenvolvimento.');
        } catch (DmlException e) {
            for(Integer j = 0; j < e.getNumDml(); j++) {
                System.debug('Erro ao inserir Lead: ' + e.getDmlMessage(j));
            }
        }
        
    }
}