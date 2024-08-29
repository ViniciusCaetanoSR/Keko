public with sharing class AccountUtils {

    //AccountUtils.createAccount();

    public static void createAccount() {

        Account newAccount = new Account();

        List<String> streets = new List<String>{'Rua das Flores', 'Avenida Paulista', 'Rua dos Alfeneiros', 'Avenida Atlântica', 'Rua Augusta'};
        List<String> cities = new List<String>{'São Paulo', 'Rio de Janeiro', 'Belo Horizonte', 'Curitiba', 'Porto Alegre'};
        List<String> states = new List<String>{'SP', 'RJ', 'MG', 'PR', 'RS'};
        List<String> neighborhoods = new List<String>{'Centro', 'Bela Vista', 'Copacabana', 'Savassi', 'Jardim Botânico'};
        
        String baseCNPJ = generateRandomCNPJ();
        String postalCode = String.valueOf(Math.mod(Math.abs(Crypto.getRandomInteger()), 100000));
        String phone = generateRandomPhone();
        String uniqueId = String.valueOf(Math.abs(Crypto.getRandomLong()));
        String street = streets[Math.mod(Math.abs(Crypto.getRandomInteger()), streets.size())];
        String city = cities[Math.mod(Math.abs(Crypto.getRandomInteger()), cities.size())];
        String state = states[Math.mod(Math.abs(Crypto.getRandomInteger()), states.size())];
        String neighborhood = neighborhoods[Math.mod(Math.abs(Crypto.getRandomInteger()), neighborhoods.size())];
        String streetNumber = String.valueOf(Math.mod(Math.abs(Crypto.getRandomInteger()), 1000));
        String recordtypeId =  [SELECT Id FROM RecordType WHERE DeveloperName = 'Varejo' AND SObjectType = 'Account' LIMIT 1].Id;
        String name = getNextAccountName();

        newAccount.Name = name;
        newAccount.RazaoSocial__c = name; 
        newAccount.CNPJ__c = baseCNPJ; 
        newAccount.Email_Comercial__c = uniqueId + '@test.com'; 
        newAccount.BillingStreet = street + ', '+streetNumber; 
        newAccount.BillingStreet = street + ', ' + streetNumber + ', Casa';  
        newAccount.BillingCity = city; 
        newAccount.BillingState = state;  
        newAccount.BillingCountry = 'BRASIL'; 
        newAccount.BillingPostalCode = postalCode; 
        newAccount.Phone = phone;
        newAccount.Ramo_de_Atividade__c = 'Lojista';
        newAccount.Neighborhood__c = neighborhood;
        newAccount.Mercado__c = 'Varejo';
        newAccount.RecordTypeId = recordtypeId;
        newAccount.Segmento__c = 'After Nacional';
        newAccount.Condicoes_de_Pagamento__c = '30 dias';
        newAccount.codigoCondicaoPagamento__c = '130';
        
        try {
            insert newAccount;
            System.debug('Conta criada com sucesso: ' + newAccount.Id);
        } catch (Exception e) {
            System.debug('Erro ao criar conta: ' + e.getMessage());
        }
    }

    public static String generateRandomCNPJ() {
        String baseCNPJ = '';
        for (Integer i = 0; i < 12; i++) {
            baseCNPJ += String.valueOf(Math.mod(Math.abs(Crypto.getRandomInteger()), 10));
        }
        Integer[] weights1 = new Integer[] {5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
            Integer[] weights2 = new Integer[] {6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
                
                Integer sum1 = 0;
        for (Integer i = 0; i < weights1.size(); i++) {
            sum1 += Integer.valueOf(baseCNPJ.substring(i, i + 1)) * weights1[i];
        }
        
        Integer mod1 = Math.mod(sum1, 11);
        Integer firstDigit = (mod1 < 2) ? 0 : 11 - mod1;
        baseCNPJ += String.valueOf(firstDigit);
        
        Integer sum2 = 0;
        for (Integer i = 0; i < weights2.size(); i++) {
            sum2 += Integer.valueOf(baseCNPJ.substring(i, i + 1)) * weights2[i];
        }
        
        Integer mod2 = Math.mod(sum2, 11);
        Integer secondDigit = (mod2 < 2) ? 0 : 11 - mod2;
        return baseCNPJ + String.valueOf(secondDigit);
    }

    public static String generateRandomPhone() {

        String prefix = '+55319';
        String randomDigits = '';
        
        for (Integer i = 0; i < 8; i++) {
            Integer randomDigit = Math.floor(Math.random() * 10).intValue(); 
            randomDigits += String.valueOf(randomDigit);
        }
        
        return prefix + randomDigits;
    }

    public static String getNextAccountName() {

        String baseName = '<<Teste>> ';

        List<Account> accounts = [SELECT Id, Name 
                                  FROM Account 
                                  WHERE Name LIKE '%<<Teste>> %' 
                                  ORDER BY CreatedDate DESC 
                                  LIMIT 1];
        
        String lastName;
        if (!accounts.isEmpty()) {
            lastName = accounts[0].Name;
        } else {
            lastName = null;
        }
        
        Integer currentNumber = 0;
        if (lastName != null && lastName.startsWith(baseName)) {
            String numberPart = lastName.replace(baseName, '');
            try {
                currentNumber = Integer.valueOf(numberPart);
            } catch (Exception e) {
                System.debug('Erro ao converter o número: ' + e.getMessage());
            }
        }
        
        Integer nextNumber = currentNumber + 1;
        
        String nextNumberFormatted = String.valueOf(nextNumber);
        
        while (nextNumberFormatted.length() < 4) {
            nextNumberFormatted = '0' + nextNumberFormatted;
        }
        
        System.debug(baseName + nextNumberFormatted);
        return baseName + nextNumberFormatted;
    }

    public static void deleteTestRecordsCreatedToday() {

        Date today = Date.today();
        
        List<Account> accountsToDelete = [SELECT Id FROM Account WHERE CreatedDate = TODAY AND Name like '%<<Teste>>%'];
        
        List<Contact> contactsToDelete = [SELECT Id FROM Contact WHERE CreatedDate = TODAY AND Name like '%<<Teste>>%'];
        
        List<Opportunity> opportunitiesToDelete = [SELECT Id FROM Opportunity WHERE CreatedDate = TODAY AND Name like '%<<Teste>>%'];
        
        List<Lead> leadsToDelete = [SELECT Id FROM Lead WHERE CreatedDate = TODAY AND Name like '%<<Teste>>%'];

        if (!opportunitiesToDelete.isEmpty()) {
            delete opportunitiesToDelete;
        }

        if (!contactsToDelete.isEmpty()) {
            delete contactsToDelete;
        } 

        if (!accountsToDelete.isEmpty()) {
            delete accountsToDelete;
        }

        if (!leadsToDelete.isEmpty()) {
            delete leadsToDelete;
        } 
    }
}