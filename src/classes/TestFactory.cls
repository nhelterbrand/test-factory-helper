/**
 * TestFactory generates records for testing purposes
 * @author Nate Helterbrand, 2019
 */
public class TestFactory {

    public static SObject createRecord(String objectName) {
        return createRecord(objectName, null);
    }

    public static SObject createRecord(String objectName, List<String> additionalFieldsToPopulate) {
        System.debug('Creating test record for ' + objectName + ' with additional fields to populate: ' + additionalFieldsToPopulate);
        SObject rec = TestFactoryHelper.populateRequiredFields(objectName, true, additionalFieldsToPopulate);

        Database.SaveResult sr = Database.insert(rec);
        List<String> errorFieldList = new List<String>();

        if (!sr.isSuccess()) {
            System.debug('Insert Error: ');

            for (Database.Error err: sr.getErrors()) {
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                errorFieldList.addAll(err.getFields());
            }

            System.debug('error fields to add to additional fields to populate: ' + errorFieldList);
            if (errorFieldList != null) {
                if (additionalFieldsToPopulate != null) {
                    additionalFieldsToPopulate.addAll(errorFieldList);
                } else {
                    additionalFieldsToPopulate = new List<String>(errorFieldList);
                }

                rec = createRecord(objectName, additionalFieldsToPopulate);
            }
        }

        return rec;
    }

    public static SObject populateRequiredFields(String objectName) {
        return TestFactoryHelper.populateRequiredFields(objectName, false, null);
    }

    // public static SObject satisfyValidationRules(String objectName) {
    //     SObject objectToReturn;
    //     // TODO

    //     return objectToReturn;
    // }
}
