@isTest
private class LeadCreatorTest {

    @isTest
    static void testCreateLeads() {

        Test.startTest();
        LeadCreator.createLeads(5, false);
        Test.stopTest();

        List<Lead> leadsCriados = [SELECT Id, FirstName, LastName, Company FROM Lead WHERE CreatedDate = TODAY];

        System.assertEquals(5, leadsCriados.size(), 'Devem ser criados 5 Leads');
        
        for (Lead l : leadsCriados) {
            System.assertNotEquals(null, l.FirstName, 'FirstName não pode ser nulo');
            System.assertNotEquals(null, l.LastName, 'LastName não pode ser nulo');
            System.assert(l.Company.contains('LTDA'), 'Company deve conter "LTDA"');
        }
    }

    @isTest
    static void testCreateLeadsError() {
        List<Lead> leadsInvalid = new List<Lead>();

        Test.startTest();
        LeadCreator.createLeads(3, true);
        Test.stopTest();
    }
}