public class AccountHelper {
    public static final Set<String> dddsBR = new Set<String>{
        '11', '12', '13', '14', '15', '16', '17', '18', '19', '21', '22', '24', '27', '28',
        '31', '32', '33', '34', '35', '37', '38', '41', '42', '43', '44', '45', '46', '47', '48', '49',
        '51', '53', '54', '55', '61', '62', '63', '64', '65', '66', '67', '68', '69', '71', '73', '74',
        '75', '77', '79', '81', '82', '83', '84', '85', '86', '87', '88', '89', '91', '92', '93', '94',
        '95', '96', '97', '98', '99'
    };

    public static void validateAndFormatPhone(Account acc) {
        if (String.isNotBlank(acc.Phone)) {
            String formattedPhone = validatePhoneNumber(acc.Phone, acc);
            acc.Phone = formattedPhone;
        }
    }
    
    public static String validatePhoneNumber(String phoneNumber, SObject objectToAddError) {
        
        if (phoneNumber.length() < 10) {
            objectToAddError.addError('Número sem DDD');
        }
        
        String formattedNumber = formatPhoneNumber(phoneNumber);
        
        if (formattedNumber.startsWith('+55') && !dddsBR.contains(formattedNumber.substring(4, 6))) {
            objectToAddError.addError('DDD Inválido');
        }
        
        if (formattedNumber.length() > 17) {
            objectToAddError.addError('Verifique quantidade de digitos do número');
        }
        
        return formattedNumber;
    }

    public static String formatPhoneNumber(String phoneNumber) {
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
        return phoneNumber;
    }
    
}