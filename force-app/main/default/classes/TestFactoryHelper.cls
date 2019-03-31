public class TestFactoryHelper {

    public static Map<String, SObject> createdSObjects = new Map<String, SObject>();

    public static SObject populateRequiredFields(String objectName, Boolean createReferenceFieldValues, List<String> additionalFieldsToPopulate) {
        System.debug('populating required fields for objectName = ' + objectName);
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        Set<String> additionalRequiredFields = new Set<String>();
        if (objectType == null) {
            // TODO throw error that object name doesn't exist
        }

        if (additionalFieldsToPopulate != null) {
            additionalRequiredFields = cleanAdditionalFieldsList(objectName, additionalFieldsToPopulate);
            System.debug('additional Required Fields added: ' + additionalRequiredFields);
        }

        // loads the sobject with all default fields populated already
        SObject sObjectRecord = objectType.newSObject(null, true);
        Map<String, Schema.SObjectField> fieldMap = objectType.getDescribe().fields.getMap();

        for (String fieldName : fieldMap.keySet()) {
            Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();

            // look for fields that cannot be null and can be updated
            if (shouldPopulateField(fieldDescribe, createReferenceFieldValues, additionalRequiredFields)) {
                sObjectRecord = populateField(sObjectRecord, fieldDescribe);
            }
        }

        return sObjectRecord;
    }

    /**
     * identifies a field as being required and needing to be populated to create a record for that object
     * @param  fieldDescribe fieldDescribe
     * @return               shouldPopulate is true when the field needs to be populated
     */
    public static Boolean shouldPopulateField(Schema.DescribeFieldResult fieldDescribe, Boolean createReferenceFieldValues, Set<String> additionalRequiredFields) {
        Boolean shouldPopulate = false;

        if (fieldDescribe.isNillable() == false &&
            fieldDescribe.isCreateable() == true &&
            fieldDescribe.getDefaultValue() == null)
        {
            shouldPopulate = true;
        }

        if (shouldPopulate == true && createReferenceFieldValues == false && fieldDescribe.getType().name().toLowerCase() == 'reference') {
            shouldPopulate = false;
        }

        if (additionalRequiredFields.contains(fieldDescribe.getName())) {
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
            String objectName = objectDescribe.getName();

            if (objectName == 'User') {
                valueToReturn = UserInfo.getUserId();
            } else if (objectName == 'Profile') {
                valueToReturn = UserInfo.getProfileId();
            } else if (objectName == 'Pricebook2') {
                valueToReturn = Test.getStandardPricebookId();
            } else {
                if (objectDescribe.isCreateable() == true && objectDescribe.isAccessible() == true) {
                    System.debug('need to create reference field record of type = ' + objectName);
                    SObject referencedRecord = stype.newSObject();

                    // we might have already created an sobject of this type, so why make another one?
                    if (!createdSObjects.containsKey(objectName)) {
                        referencedRecord = populateRequiredFields(objectName, true, null);
                        System.debug('adding a record of type, ' + objectName + ': ' + referencedRecord);
                        insert referencedRecord;
                        createdSObjects.put(objectName, referencedRecord);
                    } else {
                        referencedRecord = createdSObjects.get(objectName);
                    }

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

    /**
     * cleanAdditionalFieldsList only returns a set of fields that belong to the object specified
     * @param  objectName objectName description
     * @param  fieldList  fieldList description
     * @return            return description
     */
    public static Set<String> cleanAdditionalFieldsList(String objectName, List<String> fieldList) {
        System.debug('Cleaning additional fields list for object = ' + objectName + ' for list: ' + fieldList);
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.SObjectField> fieldMap = objectType.getDescribe().fields.getMap();
        Set<String> cleanFieldList = new Set<String>();

        for (String field : fieldList) {
            if (fieldMap.containsKey(field)) {
                cleanFieldList.add(field);
            }
        }

        return cleanFieldList;
    }
}
