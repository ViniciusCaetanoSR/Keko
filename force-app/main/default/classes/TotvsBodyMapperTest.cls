@isTest
private class TotvsBodyMapperTest {

    @isTest
    static void testTotvsMapper() {
        Account testAccount = new Account(
            Name = 'Test Account',
            RazaoSocial__c = 'Test Razão Social',
            Ramo_de_Atividade__c = 'Distribuidor');

        insert testAccount;

        TotvsBody result = TotvsBodyMapper.totvsMapper(testAccount);

        System.assertEquals(1, result.customerGroup);
        System.assertEquals(1, result.modality);
        System.assertEquals(100, result.representativeCode);
        System.assertEquals(testAccount.Name, result.customerName);
    }
}