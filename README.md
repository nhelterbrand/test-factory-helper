# TestFactory

## Overview

TestFactory is a helper class that provides the functionality to populate required fields onto records without having to constantly update what those required fields are due to configuration changes to Objects and Fields.

## Dev, Build and Test

## Usage

After deploying the class to your org, usage is simple and there are example use cases of the TestFactory class in TestFactoryTest.cls

```(Apex)
@isTest static void populateAccountWithRequiredFields() {
    Account rec = (Account)TestFactory.populateRequiredFields('Account');

    Test.startTest();
    insert rec;
    Test.stopTest();
}
```

The `populateRequiredFields` method does not insert the record, so that normal test case development can still be applied, but the method strives to save the step of redundently populating required fields not being tested in the test method.

## Resources

## Description of Files and Directories

## Issues
