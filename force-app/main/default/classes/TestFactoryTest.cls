/**
 * TestFactoryTests common scenarios to use TestFactory
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
        User rec = (User)TestFactory.populateRequiredFields('User');

        Test.startTest();
        insert rec;
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
        PricebookEntry rec = (PricebookEntry)TestFactory.populateRequiredFields('PricebookEntry');

        Test.startTest();
        insert rec;
        Test.stopTest();
    }

    @isTest static void populateAnyObjectWithRequiredFields() {
        List<SObject> records = new List<SObject>();

        for (Schema.SObjectType objType : Schema.getGlobalDescribe().values()) {
            String objectName = objType.getDescribe().getName();

            SObject rec = objType.newSObject();
            rec = TestFactory.populateRequiredFields(objectName);
            records.add(rec);
        }

        Test.startTest();
        Database.SaveResult[] srList = Database.insert(records, false);
        Test.stopTest();

        for (Database.SaveResult sr : srList) {
            String message = 'Successful insert of object type ' + sr.getId().getSobjectType() + ' with id = ' + sr.getId();

            if (!sr.isSuccess()) {
                for (Database.Error err : sr.getErrors()) {
                    message = 'Error insert: ' + err.getStatusCode() + ', because: ' + err.getMessage() + ' on fields ' + err.getFields();
                }
            }

            System.assertEquals(true, sr.isSuccess(), message);
        }
    }
}
