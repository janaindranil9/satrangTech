@IsTest
private class OpportunityTriggerHandlerTest {
    @IsTest
    static void testHandleAfterInsert() {
        
      
        // Create a Chatter group using the Collaboration Type
        CollaborationGroup chatterGroup = new CollaborationGroup(Name = 'High Networth Sale', CollaborationType =  'Public');
        insert chatterGroup;


        List<Opportunity> opportunities = new List<Opportunity>();
        opportunities.add(new Opportunity(Name = 'Opportunity 1', Amount = 600000, StageName = 'Closed Won', CloseDate=System.today()));
        //opportunities.add(new Opportunity(Name = 'Opportunity 2', Amount = 700000, StageName = 'Closed Won',CloseDate=System.today()));
       // opportunities.add(new Opportunity(Name = 'Opportunity 3', Amount = 400000, StageName = 'Closed Lost',CloseDate=System.today()));
        opportunities.add(new Opportunity(Name = 'Opportunity 4', Amount = 800000, StageName = 'Closed Won',CloseDate=System.today()));

        Test.startTest();
        insert opportunities;
        Test.stopTest();

        List<FeedItem> chatterPosts = [
            SELECT Body, ParentId
            FROM FeedItem
            WHERE ParentId = :'0F92t000000LGkHCAW'
            And Type='Text Post'
        ];
        System.assertEquals(2, chatterPosts.size());
        FeedItem post1 = chatterPosts[0];
        System.assertEquals('High Networth Opportunity: Opportunity 1\nAccount: null\nSalesperson: null', post1.Body);
        System.assertEquals(chatterGroup.Id, post1.ParentId);
        FeedItem post2 = chatterPosts[1];
        System.assertEquals('High Networth Opportunity: Opportunity 2\nAccount: null\nSalesperson: null', post2.Body);
        System.assertEquals(chatterGroup.Id, post2.ParentId);
      
    }
}