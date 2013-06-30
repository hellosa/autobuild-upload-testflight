#!/bin/sh

# autobuild-upload-testflight.sh
#
# Created by hellosa on 16/05/2013.
#
# Description:
#
#   Build and archive your xcode project from command line, upload to testflight and notify your team members after finishing.
#   if you don't want the testflight email notification, just comment the following two lines:
#
#     -F distribution_lists="${DISTRIBUTION_LISTS}" \
#     -F notify="True"
#
#
# Thanks to:
#   http://developmentseed.org/blog/2011/sep/02/automating-development-uploads-testflight-xcode/
#   http://blog.octo.com/en/automating-over-the-air-deployment-for-iphone/
#   https://github.com/noodlewerk/NWTestFlightUploader/blob/master/NWTestFlightUploader.sh

####################### Config Start #####################################
# *** Please fill in the blank before you user it ***

# your project home, like /Users/hello/github/momo/
PROJDIR=""
# your project name, like momo
PROJECT_NAME=""
# your product name (maybe yours is different from the PROJECT_NAME)
PRODUCT_NAME=""
# you can keep it remain
TARGET_SDK="iphoneos"
# you can keep it remain
PROJECT_BUILDDIR="${PROJDIR}/build/Release-iphoneos"
# Find your API_TOKEN at: https://testflightapp.com/account/
API_TOKEN=""
# Find your TEAM_TOKEN at: https://testflightapp.com/dashboard/team/edit/
TEAM_TOKEN=""
# like "iPhone Developer: xxx xxx (xxx)
SIGNING_IDENTITY=""
# Find your xxx.mobileprovision here: ${HOME}/Library/MobileDevice/Provisioning Profiles/
PROVISIONING_PROFILE=""
# Find the answer here: http://help.testflightapp.com/customer/portal/articles/890615-what-are-distribution-list-and-how-do-i-use-them-
DISTRIBUTION_LISTS=""

DSYM="${PROJECT_BUILDDIR}/${PRODUCT_NAME}.app.dSYM"
APP="${PROJECT_BUILDDIR}/${PRODUCT_NAME}.app"
#LOG="/tmp/testflight.log"

######################## Config End #####################################



# compile project
echo "Building Project"
cd "${PROJDIR}"
xcodebuild -target "${PROJECT_NAME}" -sdk "${TARGET_SDK}" -configuration Release

#Check if build succeeded
if [ $? != 0 ]
then
  exit 1
fi



#/usr/bin/open -a /Applications/Utilities/Console.app $LOG

#echo -n "Creating .ipa for ${PRODUCT_NAME}... " > $LOG
echo "Creating .ipa for ${PRODUCT_NAME}"

/bin/rm "/tmp/${PRODUCT_NAME}.ipa"
#/usr/bin/xcrun -sdk iphoneos PackageApplication -v "${PROJECT_BUILDDIR}/${APPLICATION_NAME}.app" -o "${BUILD_HISTORY_DIR}/${APPLICATION_NAME}.ipa" --sign "${DEVELOPPER_NAME}" --embed "${PROVISONNING_PROFILE}"
/usr/bin/xcrun -sdk iphoneos PackageApplication -v "${APP}" -o "/tmp/${PRODUCT_NAME}.ipa" --sign "${SIGNING_IDENTITY}" --embed "${PROVISIONING_PROFILE}"

#echo "done." >> $LOG
echo "Created .ipa for ${PRODUCT_NAME}"

#echo -n "Zipping .dSYM for ${PRODUCT_NAME}..." >> $LOG
echo "Zipping .dSYM for ${PRODUCT_NAME}"

/bin/rm "/tmp/${PRODUCT_NAME}.dSYM.zip"
/usr/bin/zip -r "/tmp/${PRODUCT_NAME}.dSYM.zip" "${DSYM}"

#echo "done." >> $LOG
echo "Created .dSYM for ${PRODUCT_NAME}"

#echo -n "Uploading to TestFlight... " >> $LOG
echo "Uploading to TestFlight"

/usr/bin/curl "http://testflightapp.com/api/builds.json" \
-F file=@"/tmp/${PRODUCT_NAME}.ipa" \
-F dsym=@"/tmp/${PRODUCT_NAME}.dSYM.zip" \
-F api_token="${API_TOKEN}" \
-F team_token="${TEAM_TOKEN}" \
-F notes="Build uploaded automatically from Xcode." \
-F distribution_lists="${DISTRIBUTION_LISTS}" \
-F notify="True"

#echo "done." >> $LOG
echo "Uploaded to TestFlight" | /usr/bin/open "https://testflightapp.com/dashboard/builds/"
