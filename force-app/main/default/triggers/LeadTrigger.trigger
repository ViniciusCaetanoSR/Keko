trigger LeadTrigger on Lead (before insert, before update) {
    for (Lead lead : Trigger.new) {
        AccountHelper.validateAndFormatPhone(lead);
    }
}