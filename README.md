# Test Factory Helper

## Overview

TestFactory is a helper class that provides the functionality to populate required fields onto records without having to constantly update what those required fields are due to configuration changes to Objects and Fields.

This class can help be the foundation for the usual scenario of creating a class just to create test data for test methods.

[![Deploy](https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png)](https://githubsfdeploy.herokuapp.com/?owner=nhelterbrand&repo=test-factory-helper)

### Usage and Methods

- `createRecord(String objectName)`
    - creates a record of the object specified in the objectName parameter with the required fields populated.
- `createRecord(String objectName, List<String> additionalFieldsToPopulate)`
    - creates a record and allows a list of field names that aren't marked as required in the system but need to be populated.
- `populateRequiredFields(String objectName)`
    - does not create a record, but returns the record with required fields populated.

### `createRecord(String objectName)`

creates a record of the object specified in the objectName parameter with the required fields populated.

**Signature**
`public static SObject createRecord(String objectName)`

**Parameters**
*objectName*
Type: `String`

**Return Value**
Type: `SObject`

Example

```(Apex)
@isTest static void populateAccountWithRequiredFields() {
    Test.startTest();
    Account rec = (Account)TestFactory.createRecord('Account');
    Test.stopTest();
}
```

### `createRecord(String objectName, List<String> additionalFieldsToPopulate)`

creates a record and allows a list of field names that aren't marked as required in the system but need to be populated.

**Signature**
`public static SObject createRecord(String objectName, List<String> additionalFieldsToPopulate)`

**Parameters**
*objectName*
Type: `String`

*additionalFieldsToPopulate*
Type: `List<String>`

**Return Value**
Type: `SObject`

Example

```(Apex)
@isTest static void populateAccountWithRequiredFields() {
    Test.startTest();
    Account rec = (Account)TestFactory.createRecord('Account', new List<String>{'Phone'});
    Test.stopTest();
}
```

### `populateRequiredFields(String objectName)`

does not create a record, but returns the record with required fields populated.

**Signature**
`public static SObject populateRequiredFields(String objectName)`

**Parameters**
*objectName*
Type: `String`

**Return Value**
Type: `SObject`

Example

```(Apex)
@isTest static void populateAccountWithRequiredFields() {
    Account rec = (Account)TestFactory.populateRequiredFields('Account');

    Test.startTest();
    insert rec;
    Test.stopTest();
}
```

## Dev, Build, Test

If you do not have a dev hub setup, please refer to Saleforce documentation on getting started with Salesforce DX.

Fork this repository and if you already have a dev hub setup, then use the `scratch-org.sh` bash script to create your scratch org, push the code to the scratch org, and then the script will open the newly created scratch org for quickly getting up and running.

Then when you're ready to package up the code you've changed, run this script:
`sfdx force:source:convert --outputdir src --packagename TestFactoryPackage`

That will update the src folder which contains the Metadata API friendly package that can be deployed to Sandboxes/Production environments and is what the "Deploy to Salesforce" button uses.

## Issues
