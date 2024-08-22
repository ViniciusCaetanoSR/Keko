public with sharing class TotvsBodyMapper {

    private static String remocaoCaracteresESpecial(String input) {
        if(input == null) return null;

        return input.replaceAll('[^0-9]', '');
    }

    public static TotvsBody totvsMapper(Account conta) {
        TotvsBody request = new TotvsBody();
        
        request.customerGroup = 1;
        request.shortName = conta.Name;
        
        request.customerName = conta.RazaoSocial__c;
        request.address = conta.BillingStreet;
        request.country = conta.BillingCountry;
        request.billingAddress = conta.BillingStreet;
        request.billingCity = conta.BillingCity;
        request.billingCompleteAddress = conta.BillingStreet;
        request.billingCountry = conta.BillingCountry;
        request.billingNeighborhood = conta.BillingCity;
        request.billingState = conta.BillingState;
        request.billingZipCode = remocaoCaracteresESpecial(conta.BillingPostalCode);
        request.city = conta.BillingCity;
        request.completeAddress = conta.BillingStreet;
        request.neighborhood = conta.BillingCity;
        request.state = conta.BillingState;
        request.zipCode = remocaoCaracteresESpecial(conta.BillingPostalCode);
        request.email = conta.email_comercial__c;
        request.entityType = 2;
        request.personalId = remocaoCaracteresESpecial(conta.CNPJ__c);
        request.billingPersonalId = remocaoCaracteresESpecial(conta.CNPJ__c);
        request.billingIbgeCode = 0;

        System.debug('TOTVS REQUEST: ' + request);
        
        return request;
    } 
}