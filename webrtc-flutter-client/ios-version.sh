#!/usr/bin/env bash -e

_INFOPLIST_DIR="ios/Runner/Info.plist"

_PACKAGE_VERSION=$(cat pubspec.yaml | grep version | head -1 | awk -F: '{ print $2 }' | sed 's/[: ']//g'')

# Set BUILD_NUMBER to the value 1 only if it is unset.
: ${BUILD_NUMBER=$(expr $(git log -1 --pretty=format:%ct) / 3600)}

# Update plist with new values

BUNDLE_VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${_INFOPLIST_DIR}")
if [ "$BUNDLE_VERSION" != "$BUILD_NUMBER" ]
then
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_NUMBER" "${_INFOPLIST_DIR}"
fi

/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${_PACKAGE_VERSION#*v}" "${_INFOPLIST_DIR}"

echo "****************************************"
echo "PACKAGE_VERSION: " $_PACKAGE_VERSION
echo "BUILD_NUMBER: " $BUILD_NUMBER
echo "****************************************"
