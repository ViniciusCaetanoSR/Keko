@isTest
private class AccountSelectorTest {

    @TestSetup
    static void createData() {
        Account testAccount = new Account(
            Name = 'Test Account',
            RazaoSocial__c = 'Test Razão Social',
            Ramo_de_Atividade__c = 'Distribuidor');
        insert testAccount;
    }

    @isTest
    static void testSelectAccountById() {
        Test.startTest();

        Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'Test Account' LIMIT 1];

        Account resultAccount = AccountSelector.selectAccountById(testAccount.Id);
        
        System.assertNotEquals(null, resultAccount, 'A conta não deveria ser nula');
        System.assertEquals(testAccount.Id, resultAccount.Id, 'Os IDs das contas deveriam ser iguais');
        System.assertEquals('Test Account', resultAccount.Name, 'Os nomes das contas deveriam ser iguais.');

        Test.stopTest();
    }

    // @isTest
    // static void testSelectAccountByIdWhenNotFound() {
    //     Test.startTest();

    //     Account resultAccount = AccountSelector.selectAccountById('01');

    //     System.assertEquals( null, resultAccount, 'A conta deveria ser nula.');

    //     Test.stopTest();
    // }
}