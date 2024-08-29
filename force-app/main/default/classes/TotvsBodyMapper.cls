public with sharing class TotvsBodyMapper {

    private static String remocaoCaracteresESpecial(String input) {
        if(input == null) return null;

        return input.replaceAll('[^0-9]', '');
    }
    
    private static Integer transformacaoInteiro(Decimal value) {
        if (value == null) return 0;
        return value.intValue();
    }

    private static Integer transformacaoTextoInteiro(String value) {
        if (String.isNotBlank(value)) {
            try {
                return Integer.valueOf(value);
            } catch (Exception e) {
                return 0;
            }
        }
        return 0;
    }

    public static TotvsBody totvsMapper(Account conta) {
        TotvsBody request = new TotvsBody();
        
        TotvsAPI__c totvsApi = TotvsAPI__c.getValues('accesses');
        
        System.debug('CONTA TOTVS: ' + conta);

        List<Bandeira__mdt> listaBandeiraTotvs = [SELECT CustomerGroup__c, RepresentativeCode__c FROM Bandeira__mdt WHERE Name__c = :conta.Bandeira__c LIMIT 1];
        Bandeira__mdt camposBandeiraTotvs;
        if (!listaBandeiraTotvs.isEmpty()) {
            camposBandeiraTotvs = listaBandeiraTotvs[0];
            System.debug('CAMPOS: ' + camposBandeiraTotvs);
        } else {
            camposBandeiraTotvs = new Bandeira__mdt();
            System.debug('CAMPOS: ' + camposBandeiraTotvs);
        }

        List<PaymentCondition__mdt> listaPaymentTotvs = [SELECT PaymentTerms__c FROM PaymentCondition__mdt WHERE Name__c = :conta.Condicoes_de_Pagamento__c LIMIT 1];
        PaymentCondition__mdt campoPaymentTotvs;
        if (!listaPaymentTotvs.isEmpty()) {
            campoPaymentTotvs = listaPaymentTotvs[0];
            System.debug('CAMPOS: ' + campoPaymentTotvs);
        }
        
        request.shortName = conta.NomeAbreviado__c;
        request.city = conta.BillingCity;
        request.billingCity = conta.BillingCity;
        request.country = conta.BillingCountry;
        request.billingCountry = conta.BillingCountry;
        request.billingState = conta.BillingState;
        request.state = conta.BillingState;
        request.billingZipCode = remocaoCaracteresESpecial(conta.BillingPostalCode);
        request.zipCode = remocaoCaracteresESpecial(conta.BillingPostalCode);
        request.email = conta.email_comercial__c;
        request.customerName = conta.RazaoSocial__c;
        request.personalId = remocaoCaracteresESpecial(conta.CNPJ__c);
        request.billingPersonalId = remocaoCaracteresESpecial(conta.CNPJ__c);
        request.phone1 = remocaoCaracteresESpecial(conta.Telefone_fixo__c);
        request.billingCompleteAddress = conta.BillingStreet;
        request.completeAddress = conta.BillingStreet;
        request.address = conta.BillingStreet;
        request.billingAddress = conta.BillingStreet;
        request.activityBranch = conta.Ramo_de_Atividade__c;
        request.salesChannel = transformacaoTextoInteiro(conta.Cod_Canal__c);
        request.customerGroup = transformacaoInteiro(camposBandeiraTotvs.CustomerGroup__c);
        request.representativeCode = transformacaoInteiro(camposBandeiraTotvs.RepresentativeCode__c);
        request.paymentTerms = transformacaoInteiro(campoPaymentTotvs.PaymentTerms__c);
        request.NFeEmail = conta.email_DANFE_xml__c;
        // request.parentName = 'Nome do Pai';
        request.tradeName = conta.Name;
        request.billingNeighborhood = conta.Neighborhood__c;
        request.municipalRegistration = conta.MunicipalRegistration__c;
        request.defaultHolder = transformacaoInteiro(totvsApi.DefaultHolder__c);
        request.defaultModality = transformacaoInteiro(totvsApi.DefaultModality__c);
        request.entityType = transformacaoInteiro(totvsApi.EntityType__c);
        request.modality = transformacaoInteiro(totvsApi.Modality__c);
        request.neighborhood = conta.Neighborhood__c;
        request.billingIbgeCode = transformacaoInteiro(totvsApi.IbgeCode__c);
        
        
       // request.additionalCredit = 0;
       // request.bank = 0;
       // request.bankBranch = '0';
       // request.credit = 1;
       // request.creditLimit = 5000.00;
       // request.creditLimitCurrency = 0;
       // request.creditLimitDate = Date.newInstance(2024, 8, 7);
       // request.creditLimitEnd = Date.newInstance(2025, 8, 7);
       // request.creditSuspendedCustomer = false;
       // request.customerClassification = 1;
       // request.customerBalance = 0;
       // request.deliveryCode = 'Padrão';
       // request.extension1 = 'Extensão 1';
       // request.extension2 = 'Extensão 2';
       // request.holder = 0;
       // request.homePage = 'http://www.exemplo.com';
       // request.ibgeCode = 0;
       // request.ICMSTaxpayer = true;
       // request.implementationDate = Date.newInstance(2020, 1, 1);
       // request.interstateTransactionType = '641001';
       // request.lastSale = Date.newInstance(2023, 12, 31);
       // request.monthsInactive = 0;
       // request.partialInvoicing = true;
       // request.phone2 = '87654321';
       // request.priceTable = '0022417A';
       // request.productLine = 'Linha de Produtos';
       // request.registrationINSS = 'INSS12345';
       // request.regionCode = 'Região';
       // request.shortRegion = 'Região Curta';
       // request.standardCarrierCode = 51;
       // request.stateRegistration = 'Registro Estadual';
       // request.supplierGroup = 0;
       // request.transactionType = '641001';
       // request.type = 1;
       // request.updateDate = Date.newInstance(2024, 8, 7);
       // request.updateTime = '12:00:00';
       // request.lastUpdate = '2024-08-07T12:00:00Z';
       // request.billingCustomer = 123;
       // request.standardRevenue = 10000;

       // request.customerContacts = new List<TotvsBody.CustomerContacts>();
       // List<Contact> contacts = [SELECT Id, Name, Email, Phone FROM Contact WHERE AccountId = :conta.Id];
       // Integer sequence = 1;
        
       // for(Contact contact : contacts) {
           // TotvsBody.CustomerContacts customerContact = new TotvsBody.CustomerContacts();

            
           // customerContact.contactArea = 'Área Contato';
           // customerContact.contactName = 'Contato Exemplo ' + sequence++;
           // customerContact.customerCode = 12345;
           //  customerContact.email = conta.email_comercial__c;
           // customerContact.office = 'Escritório Exemplo';
           // customerContact.phone = '1234-5678';
           // customerContact.sequence = 1;
           // customerContact.telefax = '1234-5678';
            
           // request.customerContacts.add(customerContact);
       // }

       // request.deliveryPlaces = new List<TotvsBody.DeliveryPlaces>();
       // TotvsBody.DeliveryPlaces deliveryPlace = new TotvsBody.DeliveryPlaces();
        
       // deliveryPlace.address = 'RUA RIBEIRO, 458';
       // deliveryPlace.city = conta.BillingCity;
       // deliveryPlace.completeAddress = 'RUA RIBEIRO, 458, CASA';
       // deliveryPlace.deliveryCode = 'DEL00';
       // deliveryPlace.mailBox = 'caixa @entrega.com';
       // deliveryPlace.neighborhood = conta.BillingCity;
       // deliveryPlace.stateRegistration = 'Registro Estadual ';
       // deliveryPlace.personalId = conta.CNPJ__c;
       // deliveryPlace.shortName = '';
       // deliveryPlace.state = conta.BillingState;
       // deliveryPlace.zipCode = '02168060';
       // deliveryPlace.country = conta.BillingCountry;
       // deliveryPlace.ibgeCode = 0; 
       // request.deliveryPlaces.add(deliveryPlace);
        

        System.debug('TOTVS REQUEST: ' + request);
        
        return request;
    } 
}