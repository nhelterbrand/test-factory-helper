/**
 * tests common scenarios to use TestFactory
 * @author Nate Helterbrand, 2019
 */
@isTest
private class TestFactoryTest {

    @isTest static void populateAccountWithRequiredFields() {
        Account rec = (Account)TestFactory.populateRequiredFields('Account');

        Test.startTest();
        insert rec;
        Test.stopTest();
    }

    @isTest static void populateContactWithRequiredFields() {
        Contact rec = (Contact)TestFactory.populateRequiredFields('Contact');

        Test.startTest();
        insert rec;
        Test.stopTest();
    }

    @isTest static void populateLeadWithRequiredFields() {
        Lead rec = (Lead)TestFactory.populateRequiredFields('Lead');

        Test.startTest();
        insert rec;
        Test.stopTest();
    }

    @isTest static void populateOpportunityWithRequiredFields() {
        Opportunity rec = (Opportunity)TestFactory.populateRequiredFields('Opportunity');

        Test.startTest();
        insert rec;
        Test.stopTest();
    }

    @isTest static void populateUserWithRequiredFields() {
        Test.startTest();
        User rec = (User)TestFactory.createRecord('User');
        Test.stopTest();
    }

    @isTest static void populateTaskWithRequiredFields() {
        Task rec = (Task)TestFactory.populateRequiredFields('Task');

        Test.startTest();
        insert rec;
        Test.stopTest();
    }

    @isTest static void populateCaseWithRequiredFields() {
        Case rec = (Case)TestFactory.populateRequiredFields('Case');

        Test.startTest();
        insert rec;
        Test.stopTest();
    }

    @isTest static void populatePricebookEntryWithRequiredFields() {
        Test.startTest();
        PricebookEntry rec = (PricebookEntry)TestFactory.createRecord('PricebookEntry');
        Test.stopTest();
    }

    // @isTest static void populateGroupRequiredFields() {
    //     Group rec = (Group)TestFactory.populateRequiredFields('Group');

    //     Test.startTest();
    //     insert rec;
    //     Test.stopTest();
    // }

    // @isTest static void createFeedItem() {
    //     Test.startTest();
    //     FeedItem rec = (FeedItem)TestFactory.createRecord('FeedItem');
    //     Test.stopTest();
    // }

    // @isTest static void populateAnyObjectWithRequiredFields() {
    //     List<SObject> records = new List<SObject>();

    //     for (Schema.SObjectType objType : Schema.getGlobalDescribe().values()) {
    //         Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

    //         if (objDescribe.isCreateable() && objDescribe.isAccessible()) {
    //             String objectName = objDescribe.getName();

    //             SObject rec = objType.newSObject();
    //             rec = TestFactory.populateRequiredFields(objectName);
    //             records.add(rec);
    //         }
    //     }

    //     System.debug('attempting to insert ' + records.size() + ' different object records');

    //     Test.startTest();
    //     Database.SaveResult[] srList = Database.insert(records, false);
    //     Test.stopTest();

    //     for (Database.SaveResult sr : srList) {
    //         String message = 'Successful insert of object type ' + sr.getId().getSobjectType() + ' with id = ' + sr.getId();

    //         if (!sr.isSuccess()) {
    //             for (Database.Error err : sr.getErrors()) {
    //                 message = 'Error insert: ' + err.getStatusCode() + ', because: ' + err.getMessage() + ' on fields ' + err.getFields();
    //             }
    //         }

    //         System.assertEquals(true, sr.isSuccess(), message);
    //     }
    // }
}
