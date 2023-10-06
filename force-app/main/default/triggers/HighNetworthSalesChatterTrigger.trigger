trigger HighNetworthSalesChatterTrigger on Opportunity (after insert,after update) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        if(Trigger.isInsert){
        OpportunityTriggerHandler.handleAfterInsert(Trigger.new);
        }
        if(Trigger.isUpdate){
        OpportunityTriggerHandler.handleAfterInsert(Trigger.new);
        }
        
    }
}