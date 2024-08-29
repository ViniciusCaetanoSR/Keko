trigger AccountTrigger on Account (after insert, after update, before insert, before update) {
    
     if (Trigger.isBefore) {
         if(Trigger.isInsert || Trigger.isUpdate) {
             AccountTriggerHandler.handleTrigger(Trigger.new);
         }
    }
    
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
           AccountTriggerHandler.onAfterInsert(Trigger.new);
        }

        if(Trigger.isUpdate) {
            AccountTriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);  
        }
    }
}