trigger ContactTrigger on Contact (before insert, before update) {
    for (Contact contact : Trigger.new) {
        AccountHelper.validateAndFormatPhone(contact);
    }
}