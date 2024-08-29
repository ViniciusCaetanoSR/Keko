@isTest
public class AccountHelperTest {

    @isTest
    static void testValidateAndFormatPhone_ValidNumber() {
        // Criar uma conta com número de telefone válido
        Account acc = new Account(
            Name = 'Test Account 1', 
            Mercado__c = 'Varejo', 
            Bandeira__c = 'KEKO', 
            RazaoSocial__c = 'Test Account 1', 
            Segmento__c = 'After Nacional', 
            CNPJ__c = '76097724000167', 
            Phone = '1123456789'
        );
        
        Test.startTest();
        AccountHelper.validateAndFormatPhone(acc);
        Test.stopTest();
        
        // Verificar se o número de telefone foi formatado corretamente
        System.assertEquals('+55(11)2345-6789', acc.Phone, 'Phone number should be formatted correctly');
    }
    
    @isTest
    static void testValidateAndFormatPhone_InvalidNumber_NoDDD() {
        // Criar uma conta com número de telefone sem DDD
        Account acc = new Account(
            Name = 'Test Account 2', 
            Mercado__c = 'Varejo', 
            Bandeira__c = 'KEKO', 
            RazaoSocial__c = 'Test Account 2', 
            Segmento__c = 'After Nacional', 
            CNPJ__c = '76097724000167', 
            Phone = '123456789'
        );
        
        Test.startTest();
        try {
            insert acc;
            System.assert(false, 'Exception should have been thrown for phone number without DDD.');
        } catch (DmlException ex) {
           // System.debug('Error message: ' + ex.getDmlMessage(0));
           // System.assert(ex.getDmlMessage(0).contains('Número sem DDD'), 'Error message should indicate phone number without DDD.');
        }
        Test.stopTest();
        
        // Verificar se o número de telefone não foi alterado
        System.assertEquals('123456789', acc.Phone, 'Phone number should remain unchanged');
    }
    
    @isTest
    static void testValidateAndFormatPhone_InvalidNumber_InvalidDDD() {
        // Conta com número de telefone e DDD inválido
        Account acc = new Account(
            Name = 'Test Account 3', 
            Mercado__c = 'Varejo', 
            Bandeira__c = 'KEKO', 
            RazaoSocial__c = 'Test Account 3', 
            Segmento__c = 'After Nacional', 
            CNPJ__c = '76097724000167', 
            Phone = '80988887777'
        );
        
        Test.startTest();
        try {
            insert acc;
            System.assert(false, 'Exception should have been thrown for phone number with invalid DDD.');
        } catch (DmlException ex) {
            //System.assert(ex.getDmlMessage(0).contains('DDD Inválido'), 'Error message should indicate invalid DDD.');
        }
        Test.stopTest();
        
        System.assertEquals('80988887777', acc.Phone, 'Phone number should remain unchanged');
    }
    
    @isTest
    static void testValidateAndFormatPhone_InvalidNumber_TooManyDigits() {
        // Criar uma conta com número de telefone com muitos dígitos
        Account acc = new Account(
            Name = 'Test Account 4', 
            Mercado__c = 'Varejo', 
            Bandeira__c = 'KEKO', 
            RazaoSocial__c = 'Test Account 4', 
            Segmento__c = 'After Nacional', 
            CNPJ__c = '76097724000167', 
            Phone = '+551112345678901234'
        );
        
        Test.startTest();
        try {
            insert acc;
            System.assert(false, 'Exception should have been thrown for phone number with too many digits.');
        } catch (DmlException ex) {
           // System.assert(ex.getDmlMessage(0).contains('Verifique quantidade de digitos do número'), 'Error message should indicate phone number with too many digits.');
        }
        Test.stopTest();
        
        // Verificar se o número de telefone não foi alterado
        System.assertEquals('+551112345678901234', acc.Phone, 'Phone number should remain unchanged');
    }
}