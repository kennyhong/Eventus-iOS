# Eventus-iOS

### Testing Notes:

#### General

We cannot guarantee persistence of a state between setup() and teardown() due to the random de-allocation of variables on the heap. This is the reason for the additional setup and teardown functions that pass data through our test functions to limit duplicate code

Additionally, there exists an issue with Xcode where occasionally the test suite fails to perform a test causing it to fail. If this happens you may re-run the test suite as a whole, or re-run the specific test class to verify that the tests do not in fact fail. The error is as follows:

The request was denied by service delegate (SBMainWorkspace) for reason: Busy ("Application "kierancairney.Eventus" is installing or uninstalling, and cannot be launched").

#### QR Scanner

Testing the QR code scanner to implement adding an event to iOS calendar would require physical scanning of QR codes with the iOS camera in order to verify the encoding. As a result, we can not test this feature with automated tests, similar to how other controllers are being tested. Additionally, due to results of the scan being tightly coupled to the feature and to preserve proper encapsulation of variables/functions, we could not implement testing for the majority of this feature.
