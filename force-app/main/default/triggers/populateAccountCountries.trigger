trigger populateAccountCountries on Contact (after insert,after update ,after delete,after undelete ) {
    Set<Id> accIds= new Set<Id>();
    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete){
    for(Contact con:Trigger.new){
        if(con.AccountId!=null){
            accIds.add(con.AccountId);
        }
    }
    }
    if (Trigger.isDelete) {
        for (Contact con : Trigger.old) {
           if(con.AccountId!=null){
            accIds.add(con.AccountId);
        }
        }
    }
    
    List<Account> accs= [Select Id,Account_Countries__c,(Select Id,AccountId,Contact_Country__c from Contacts) from Account where Id IN:accIds];
    Map<Id,Account> mapToUpdate = new Map<Id,Account>();
    for(Account acc:accs){
        Set<String> accCountries=new Set<String>();
        for(Contact con: acc.Contacts){
            if(con.Contact_Country__c!=null){
                accCountries.add(con.Contact_Country__c);
            }
        }
        String updateAcc=String.join(new List<String>(accCountries), ',');
        acc.Account_Countries__c=updateAcc;
        mapToUpdate.put(acc.Id, acc);
    }
    if(mapToUpdate.keySet()!=null){
        update mapToUpdate.values();
    }

}