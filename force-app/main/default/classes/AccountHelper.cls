public class AccountHelper {

    private static final String TOTVS_SETTING_NAME = 'Totvs';
    private static BypassSettings__mdt bypassSettings;

    public static final Set<String> dddsBR = new Set<String>{
        '11', '12', '13', '14', '15', '16', '17', '18', '19', '21', '22', '24', '27', '28',
        '31', '32', '33', '34', '35', '37', '38', '41', '42', '43', '44', '45', '46', '47', '48', '49',
        '51', '53', '54', '55', '61', '62', '63', '64', '65', '66', '67', '68', '69', '71', '73', '74',
        '75', '77', '79', '81', '82', '83', '84', '85', '86', '87', '88', '89', '91', '92', '93', '94',
        '95', '96', '97', '98', '99'
    };

    public static void validateAndFormatPhone(SObject obj) {

        List<String> camposTelefone = new List<String>();

        camposTelefone.add('Phone');
        camposTelefone.add('Telefone_fixo__c');
        
        if(obj instanceof Lead) {
            camposTelefone.add('MobilePhone');
        }

        if(obj instanceof Contact) {
            camposTelefone.add('AssistantPhone');
            camposTelefone.add('HomePhone');
            camposTelefone.add('OtherPhone');
            camposTelefone.add('MobilePhone');
        }

        for(String campo : camposTelefone) {
            if(obj.get(campo) != null && String.isNotBlank((String)obj.get(campo))) {
                String formattedPhone = validatePhoneNumber((String)obj.get(campo), obj);
                obj.put(campo, formattedPhone);
            }
        }
        
        // if (obj.get('Phone') != null && String.isNotBlank((String)obj.get('Phone'))) {
        //     String formattedPhone = validatePhoneNumber((String)obj.get('Phone'), obj);
        //     obj.put('Phone' ,formattedPhone);
        // }

        // if(obj.get('Telefone_fixo__c') != null && String.isNotBlank((String)obj.get('Telefone_fixo__c'))) {
        //     String formattedPhone = validatePhoneNumber((String)obj.get('Telefone_fixo__c'), obj);
        //     obj.put('Telefone_fixo__c', formattedPhone);
        // }

        // if(obj.get('AssistantPhone') != null && String.isNotBlank((String)obj.get('AssistantPhone'))) {
        //     String formattedPhone = validatePhoneNumber((String)obj.get('AssistantPhone'), obj);
        //     obj.put('AssistantPhone', formattedPhone);
        // }

        // if(obj.get('HomePhone') != null && String.isNotBlank((String)obj.get('HomePhone'))) {
        //     String formattedPhone = validatePhoneNumber((String)obj.get('HomePhone'), obj);
        //     obj.put('HomePhone', formattedPhone);
        // }

        // if(obj.get('OtherPhone') != null && String.isNotBlank((String)obj.get('OtherPhone'))) {
        //     String formattedPhone = validatePhoneNumber((String)obj.get('OtherPhone'), obj);
        //     obj.put('OtherPhone', formattedPhone);
        // }

        // if(obj.get('MobilePhone') != null && String.isNotBlank((String)obj.get('MobilePhone'))) {
        //     String formattedPhone = validatePhoneNumber((String)obj.get('MobilePhone'), obj);
        //     obj.put('MobilePhone', formattedPhone);
        // }
    }
    
    public static String validatePhoneNumber(String phoneNumber, SObject objectToAddError) {

        String formattedNumber = formatPhoneNumber(phoneNumber);
        
        if(!isValidationByPassed()) {
            if (phoneNumber.length() < 10) {
                objectToAddError.addError('Número sem DDD');
            }
            
             if (formattedNumber.startsWith('+55') && formattedNumber.length() >= 6 && !dddsBR.contains(formattedNumber.substring(4, 6))) {
                objectToAddError.addError('DDD Inválido');
             }
            
            if (formattedNumber.length() > 17) {
                objectToAddError.addError('Verifique quantidade de digitos do número');
            }
        }
        
        return formattedNumber;
    }

    public static String formatPhoneNumber(String phoneNumber) {
        

        if(!isValidationByPassed()) {
            phoneNumber = phoneNumber.replaceAll('\\s+', '').replaceAll('[^0-9+]', '');
            if (!phoneNumber.startsWith('+55') && phoneNumber.length() >= 10 && phoneNumber.length() <= 11) {
                phoneNumber = '+55' + phoneNumber;
            }
            
            if (phoneNumber.startsWith('55') && !phoneNumber.startsWith('+55')) {
                phoneNumber = '+' + phoneNumber;
            }
            
            if (phoneNumber.startsWith('+55') && phoneNumber.length() == 13) { // Para números fixos
                phoneNumber = phoneNumber.replaceFirst('(\\+\\d{2})(\\d{2})(\\d{4})(\\d{4})', '$1($2)$3-$4');
            } else if (phoneNumber.startsWith('+55') && phoneNumber.length() == 14) { // Para números móveis
                phoneNumber = phoneNumber.replaceFirst('(\\+\\d{2})(\\d{2})(\\d{5})(\\d{4})', '$1($2)$3-$4');
            }
        }
        
        return phoneNumber;
    }

    private static Boolean isValidationByPassed() {
        // Carrega as configurações apenas uma vez (lazy loading)
        if (bypassSettings == null) {
            try {
                bypassSettings = [SELECT BypassValidation__c 
                                 FROM BypassSettings__mdt 
                                 WHERE DeveloperName = :TOTVS_SETTING_NAME 
                                 LIMIT 1];
            } catch (QueryException e) {
                System.debug('Configuração BypassSettings__mdt não encontrada para ' + TOTVS_SETTING_NAME + '. Erro: ' + e.getMessage());
                return false;
            }
        }
        return bypassSettings != null && bypassSettings.BypassValidation__c;
    }
    
}