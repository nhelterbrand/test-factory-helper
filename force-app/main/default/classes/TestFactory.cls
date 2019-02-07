/**
 * TestFactory generates records for testing purposes
 * @author Nate Helterbrand, 2019
 */
public class TestFactory {

    public static SObject populateRequiredFields(String objectName) {
        System.debug('populating required fields for objectName = ' + objectName);
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        if (objectType == null) {
            // TODO throw error that object name doesn't exist
        }

        // loads the sobject with all default fields populated already
        SObject sObjectRecord = objectType.newSObject(null, true);
        Map<String, Schema.SObjectField> fieldMap = objectType.getDescribe().fields.getMap();

        for (String fieldName : fieldMap.keySet()) {
            Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();

            // look for fields that cannot be null and can be updated
            if (shouldPopulateField(fieldDescribe)) {
                try {
                    sObjectRecord = populateField(sObjectRecord, fieldDescribe);
                } catch (Exception e) {
                    System.debug('Could not populate field: ' + e.getMessage());
                }
            }
        }

        return sObjectRecord;
    }

    public static Boolean shouldPopulateField(Schema.DescribeFieldResult fieldDescribe) {
        Boolean shouldPopulate = false;

        if (fieldDescribe.isNillable() == false &&
            fieldDescribe.isCreateable() == true &&
            fieldDescribe.getDefaultValue() == null)
        {
            shouldPopulate = true;
        }

        return shouldPopulate;
    }

    public static SObject populateField(SObject sObjectRecord, Schema.DescribeFieldResult fieldDescribe) {
        String fieldTypeString = fieldDescribe.getType().name().toLowerCase();
        String fieldName = fieldDescribe.getName();
        System.debug('field Name = ' + fieldName + ' and type = ' + fieldTypeString);

        Object value = null;

        switch on fieldTypeString {
            when 'base64' {
                value = (Object)Blob.valueOf('hello');
            }
            when 'boolean' {
                value = (Object)false;
            }
            when 'currency', 'double', 'integer', 'long', 'percent' {
                value = (Object)1;
            }
            when 'date' {
                value = (Object)Date.today();
            }
            when 'datetime' {
                value = (Object)Datetime.now();
            }
            when 'email' {
                value = (Object)'test@test.com';
            }
            when 'multipicklist', 'picklist' {
                value = (Object)populatePicklistField(fieldDescribe);
            }
            when 'phone' {
                value = (Object)'555-867-5309';
            }
            when 'reference' {
                value = (Object)populateReferenceField(fieldDescribe);
            }
            when 'string', 'textarea' {
                value = (Object)generateStringValue(fieldDescribe);

                if (fieldName == 'Username') {
                    value = (Object)'test' + generateUniqueString().right(10) + '@test.com';
                }
            }
            when 'time' {
                value = (Object)Time.newInstance(1, 2, 3, 4);
            }
            when 'url' {
                value = (Object)'www.test.com';
            }
        }

        System.debug('defaulting field value with ' + value);
        if (value != null) {
            sObjectRecord.put(fieldName, value);
        }

        return sObjectRecord;
    }

    public static String populatePicklistField(Schema.DescribeFieldResult fieldDescribe) {
        List<Schema.PicklistEntry> picklistValues = fieldDescribe.getPicklistValues();
        String valueToReturn = null;

        for (Schema.PicklistEntry pv : picklistValues) {
            if (pv.isActive()) {
                valueToReturn = pv.getValue();
                break;
            }
        }

        return valueToReturn;
    }

    public static String populateReferenceField(Schema.DescribeFieldResult fieldDescribe) {
        List<Schema.sObjectType> fieldReferenceToList = fieldDescribe.getReferenceTo();
        String valueToReturn = null;

        for (Schema.sObjectType stype : fieldReferenceToList) {
            Schema.DescribeSObjectResult objectDescribe = stype.getDescribe();

            if (objectDescribe.getName() == 'User') {
                valueToReturn = UserInfo.getUserId();
            } else if (objectDescribe.getName() == 'Profile') {
                valueToReturn = UserInfo.getProfileId();
            } else {
                if (objectDescribe.isCreateable() == true && objectDescribe.isAccessible() == true) {
                    System.debug('need to create reference field record of type = ' + objectDescribe.getName());
                    SObject referencedRecord = stype.newSObject();
                    referencedRecord = populateRequiredFields(objectDescribe.getName());
                    insert referencedRecord;

                    valueToReturn = referencedRecord.Id;
                }
            }
        }

        return valueToReturn;
    }

    public static String generateStringValue(Schema.DescribeFieldResult fieldDescribe) {
        String uniqueString = generateUniqueString();
        Integer fieldLength = fieldDescribe.getLength();

        return uniqueString.left(fieldLength);
    }

    public static String generateUniqueString() {
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueString = 'test' + randomInt + dateString;

        return uniqueString;
    }

    public static SObject satisfyValidationRules(String objectName) {
        SObject objectToReturn;
        // TODO

        return objectToReturn;
    }
}
