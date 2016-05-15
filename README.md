# Branch Objective-C TestBed
## Create Your Own TestBed
1. Clone the Branch iOS SDK to your local machine: git clone https://github.com/BranchMetrics/iOS-Deferred-Deep-Linking-SDK.git
2. Copy the "Branch-TestBed-Objective-C" subfolder to a new folder
3. Open the project by clicking on Branch-TestBed.xcworkspace
4. Open the file: Branch-TestBed.entitlements
5. On the General tab of the Branch-TestBed Target:
- Update the Bundle Identifier: io.branch.{unique name of your choosing}.Branch-TestBed
- Change the Team to a team you are a member of
- Click on the Fix Issue button if it appears
6. Log in to the Branch Dashboard: https://dashboard.branch.io
7. Create a new app by selecting the drop-down menu in the upper-right-hand corner of the screen and selecting "Create new app"
8, Name the new app: Branch Objective-C TestBed
9. Open your Apple Developer portal: https://developer.apple.com
10. Browse to: https://developer.apple.com/account/ios/identifier/bundle
11. Open Identifiers | App IDs and open the entry for the app (an entry will be created as long as the Associated Domains capability has been defined for the target - and this should have already been done)
- Copy the ID: io.branch.objective-c.Branch-TestBed
- Copy the Prefix: 69TZ4MRH7U
11. On Settings | Link Settings
- Check: Always try to open app
- Check: I have an iOS App
- iOS URI Scheme: branch-testbed://
- Apple Store Search: Custom URL: https://docs.banch.io
- Check: Enable Universal Links
- Bundle Identifier: io.branch.objective-c.Branch-TestBed
- Apple App Prefix: 69TZ4MRH7U


## Creating an APK


## Test Cases
TestBed (internal testing app) (14)
connect test device to your computer via USB cable, monitor logs using this command: adb logcat -v time | grep -i branchsdk

app_name: Branch Demo [Test]
branch_key: key_test_hdcBLUy1xZ1JD0tKg7qrLcgirFmPPVJc
app_id: 119202961317450408

NOTE: Branch Demo [Test] Settings; Link Settings for Android must have Enable App Links checked
NOTE: Uninstall existing TestBed app so a new identity_id will be generated
NOTE: Android Studio must be installed to use adb tool
NOTE: use http://www.jsonparseronline.com/ to help "see" the JSON responses

Enterprise Mode

need to build the TestBed app with an Enterprise app branch_key

app_name: QAApp5 [Test]
branch_key: key_test_aidYggQQ0k80kIETucaO8hlnAyj1x3Di
branch_key: key_live_okpXadHJ8cX0eVtNunnOjilbDsi8r4a2
app_id: 219215295116497780

## Test Cases
### 1 after selecting .apk file to install an access screen should be displayed

should only see the following requests for access:
Privacy -> modify or delete the contents of your USB storage; read the contents of your USB storage
Device access -> full network access


### 2 install TestBed .apk file on testing device

#### Expected Results
should see testbed app displayed on app

should see adb logging output similar to below:

Branch Warning: You are using your test app's Branch Key. Remember to change it to live Branch Key during deployment.
posting to https://api.branch.io/v1/install
Post value = {
"is_hardware_id_real": false,
"update": 0,
"has_nfc": false,
"os": "Android",
"model": "HTC One mini",
"lat_val": 1,
"hardware_id": "6144b09f-671b-4a7e-8ccb-561fd498a6e0",
"screen_dpi": 320,
"app_version": "1.10.1",
"has_telephone": true,
"screen_width": 720,
"debug": true,
"instrumentation": {
"v1\/install-qwt": "0"
},
"branch_key": "key_test_hdcBLUy1xZ1JD0tKg7qrLcgirFmPPVJc",
"os_version": 19,
"google_advertising_id": "083faa63-d215-4e55-a7b1-50ccc61dbacf",
"is_referrable": 1,
"bluetooth": false,
"wifi": false,
"retryNumber": 0,
"carrier": "",
"brand": "HTC",
"sdk": "android1.10.1",
"bluetooth_version": "ble",
"screen_height": 1280
}
returned {"session_id":"206476479957199861","identity_id":"206476479842764699","device_fingerprint_id":"206476479800877513","browser_fingerprint_id":null,"link":"https://bnc.lt/a/key_test_hdcBLUy1xZ1JD0tKg7qrLcgirFmPPVJc?%24identity_id=237345800684865693","data":"{\"+is_first_session\":true,\"+clicked_branch_link\":false}"}


### 3 validate hardward id is false because TestBed is flagged as a test app

#### Expected Results
should have following entry in POST

"is_hardware_id_real": false


### 4 validate google advertising id is sent as part of the /v1/install POST

#### Expected Results
should have similar entry in POST

"google_advertising_id": "083faa63-d215-4e55-a7b1-50ccc61dbacf"


### 5 validate returned values

#### Expected Results
session_id
identity_id = random
device_fingerprint_id = random
browser_fingerprint_id = null
data:
- is_first_session = true
- click_branch_link = false


### 6 validate correct SDK version in adb output

#### Expected Results

"sdk": "android1.nn.nn" <- should be version of SDK being released


### 7 validate correct device info in adb output

#### Expected Results
should have similar data in adb output:

"has_nfc": false,
"os": "Android",
"model": "HTC One mini",
"screen_dpi": 320,
"has_telephone": true,
"screen_width": 720,
"os_version": 19,
"google_advertising_id": "083faa63-d215-4e55-a7b1-50ccc61dbacf",
"bluetooth": false,
"wifi": false,
"carrier": "",
"brand": "HTC",
"bluetooth_version": "ble",
"screen_height": 1280


### 8 Export & Live View -> Identities has new entry

#### Expected Results
should see new entry under the Identities section; expand All Properties and verify data matches what is displayed from adb logging output
