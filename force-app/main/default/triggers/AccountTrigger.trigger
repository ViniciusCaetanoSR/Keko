trigger AccountTrigger on Account (after insert, after update) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
           AccountTriggerHandler.onAfterInsert(Trigger.new);
        }

        if(Trigger.isUpdate) {
            AccountTriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);  
        }
    }
}