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
        try {
            TotvsAPI__c totvsApi = TotvsAPI__c.getValues('accesses');
            
            System.debug('CONTA TOTVS: ' + conta);

            List<Bandeira__mdt> listaBandeiraTotvs = [SELECT CustomerGroup__c, RepresentativeCode__c FROM Bandeira__mdt WHERE Name__c = :conta.Bandeira__c LIMIT 1];
            Bandeira__mdt camposBandeiraTotvs;
            if (!listaBandeiraTotvs.isEmpty()) {
                camposBandeiraTotvs = listaBandeiraTotvs[0];
                System.debug('Campos Bandeira1: ' + camposBandeiraTotvs);
            } else {
                camposBandeiraTotvs = new Bandeira__mdt();
                System.debug('Campos Bandeira2: ' + camposBandeiraTotvs);
            }

            List<PaymentCondition__mdt> listaPaymentTotvs = [SELECT PaymentTerms__c FROM PaymentCondition__mdt WHERE Name__c = :conta.Condicoes_de_Pagamento__c LIMIT 1];
            PaymentCondition__mdt campoPaymentTotvs;
            if (!listaPaymentTotvs.isEmpty()) {
                campoPaymentTotvs = listaPaymentTotvs[0];
                System.debug('Campos PaymentCondition: ' + campoPaymentTotvs);
            }
            
            request.shortName = conta.Name;
            request.customerName = conta.RazaoSocial__c;
            request.personalId = remocaoCaracteresESpecial(conta.CNPJ__c);
            request.email =  conta.email_comercial__c;
            request.entityType = transformacaoInteiro(totvsApi.EntityType__c);
            request.address = conta.BillingStreet;
            request.customerGroup = transformacaoInteiro(camposBandeiraTotvs.CustomerGroup__c);
            request.completeAddress = conta.BillingStreet;
            request.neighborhood = conta.Neighborhood__c;
            request.city = conta.BillingCity;
            request.state = conta.BillingState;
            request.country = conta.BillingCountry;
            request.zipCode =  remocaoCaracteresESpecial(conta.BillingPostalCode);
            request.billingAddress = conta.BillingStreet;
            request.billingCity = conta.BillingCity;
            request.billingCompleteAddress = conta.BillingStreet;
            request.billingCountry = conta.BillingCountry;
            request.billingNeighborhood = conta.Neighborhood__c;
            request.billingPersonalId = remocaoCaracteresESpecial(conta.CNPJ__c);
            request.billingState = conta.BillingState;
            request.billingZipCode =  remocaoCaracteresESpecial(conta.BillingPostalCode);
            
            request.phone1 = remocaoCaracteresESpecial(conta.Telefone_fixo__c);
            request.activityBranch = conta.Ramo_de_Atividade__c;
            request.salesChannel = transformacaoTextoInteiro(conta.Cod_Canal__c);
            request.representativeCode = transformacaoInteiro(camposBandeiraTotvs.RepresentativeCode__c);
            request.paymentTerms = transformacaoInteiro(campoPaymentTotvs.PaymentTerms__c);
            request.NFeEmail = conta.email_DANFE_xml__c;
            request.tradeName = conta.Name;
            
            request.defaultHolder = transformacaoInteiro(totvsApi.DefaultHolder__c);
            request.defaultModality = transformacaoInteiro(totvsApi.DefaultModality__c);
            request.modality = transformacaoInteiro(totvsApi.Modality__c);
    
            
            System.debug('City: ' + request.city);
            System.debug('BillingCity: ' + request.billingCity);
            System.debug('Country: ' + request.country);
            System.debug('BillingCountry: ' + request.billingCountry);
            System.debug('State: ' + request.state);
            System.debug('BillingState: ' + request.billingState);
            System.debug('ZipCode: ' + request.zipCode);
            System.debug('BillingZipCode: ' + request.billingZipCode);
            System.debug('BillingCompleteAddress: ' + request.billingCompleteAddress);
            System.debug('CompleteAddress: ' + request.completeAddress);
            System.debug('Address: ' + request.address);
            System.debug('BillingAddress: ' + request.billingAddress);
            System.debug('Bairro: ' + request.neighborhood);
            System.debug('Personal ID: ' + request.personalId);

            System.debug('TOTVS REQUEST: ' + request);
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Exception>> e.getMessage: ' + e.getMessage());
            System.debug(LoggingLevel.ERROR, 'Exception>> e.getCause: ' + e.getCause());
            System.debug(LoggingLevel.ERROR, 'Exception>> e.getLineNumber: ' + e.getLineNumber());
            System.debug(LoggingLevel.ERROR, 'Exception>> e.getStackTraceString: ' + e.getStackTraceString());
        }
        return request;
    } 
}