autobuild-upload-testflight
===========================

Build and archive your xcode project from command line, upload to testflight and notify your team members after finishing.

###HOWTO

1. First of all, configure the **Certificate** and **Provisioning Profile** on the http://developer.apple.com
    1. Open [http://developer.apple.com](http://developer.apple.com), and login in. You will see:![Image Alt](https://raw.github.com/hellosa/autobuild-upload-testflight/master/screenshot/screenshot2.png)
    2. Create a developer certificate yourself. Here is the [tutorials](http://developer.apple.com/library/ios/#documentation/IDEs/Conceptual/AppDistributionGuide/CodeSigningYourApps/CodeSigningYourApps.html) of Apple.
    3. Add your device into the device list on this [page](https://developer.apple.com/account/ios/device/deviceList.action). Just need your [UDID](http://www.innerfence.com/howto/find-iphone-unique-device-identifier-udid). 
    4. Create a development Provisioning Profile that includes your device you just added. [Tutorials](http://developer.apple.com/library/ios/#documentation/IDEs/Conceptual/AppDistributionGuide/MaintainingCertificatesandProvisioningAssets/MaintainingCertificatesandProvisioningAssets.html).


2. Secondly, configure the **Code Signing** of Xcode
    1. Select your Project in the Project navigator
    2. Select the Build Settings tab
    3. Open the "Code Signing".
    4. Choose your Developer Certificate and Provisioning Profile you just configured. Just like this: ![Image Alt](https://raw.github.com/hellosa/autobuild-upload-testflight/master/screenshot/screenshot1.png)
    5. Now, you can quit Xcode.
    
3. Finally, configure the script, autobuild-upload-testflight.sh. Fill in the blank.

    * PROJDIR: where's your PROJECT.xcodeproj located. Like "/Users/hello/github/momo/"
    * PROJECT_NAME: like momo
    * PRODUCT_NAME: maybe the same as PROJECT_NAME.
    * API_TOKEN: Find your API_TOKEN at: [https://testflightapp.com/account/](https://testflightapp.com/account/)
    * TEAM_TOKEN: Find your TEAM_TOKEN at: [https://testflightapp.com/dashboard/team/edit/](https://testflightapp.com/dashboard/team/edit/)
    * SIGNING_IDENTITY: For me, it's "iPhone Developer: Zhanchong Chen (HFUR8JNMN3)"
    * PROVISIONING_PROFILE: Find your xxx.mobileprovision here: ${HOME}/Library/MobileDevice/Provisioning Profiles/
    * DISTRIBUTION_LISTS: Find the answer here: [http://help.testflightapp.com/customer/portal/articles/890615-what-are-distribution-list-and-how-do-i-use-them-](http://help.testflightapp.com/customer/portal/articles/890615-what-are-distribution-list-and-how-do-i-use-them-)
    
4. All done. Try executing the script. If you encounter some errors, please let me know, I will fix it.
