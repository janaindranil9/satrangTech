public class OpportunityTriggerHandler {
    public static void handleAfterInsert(List<Opportunity> newOpportunities){
        list<Opportunity> highNetworthOpportunities=new list<opportunity>();
        for(Opportunity opp:newOpportunities){
            if(opp.IsClosed && opp.StageName == 'Closed Won' && opp.Amount >= 500000){
                highNetworthOpportunities.add(opp);
            }
        }
        if(!highNetworthOpportunities.isEmpty())
        {
            CollaborationGroup chatterGroup = [SELECT Id FROM CollaborationGroup WHERE Name = 'High Networth Sales' LIMIT 1]; 
            List<Opportunity> opp2=[SELECT Id, Name, Account.Name, Owner.Name FROM Opportunity where Id IN: highNetworthOpportunities];
            if(chatterGroup!=null){
            List<FeedItem> chatterPosts = new List<FeedItem>();
            for (Opportunity opp : opp2) {
                String postBody = 'High Networth Opportunity: ' + opp.Name +
                    '\nAccount: ' + opp.Account.name +
                    '\nSalesperson: ' + opp.Owner.Name;
                
                FeedItem post = new FeedItem();
                post.ParentId = chatterGroup.Id;
                post.Body = postBody;
                post.Type = 'TextPost';
                
                chatterPosts.add(post);
            }
                if(!chatterPosts.isEmpty()){
            insert chatterPosts;
                }
            }
        }
    }
}