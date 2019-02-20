/bin/sh

BUILD=`cat ./build`

echo "build:" $BUILD

PLB=/usr/libexec/PlistBuddy

for DELIVERABLE in "Heading Bug"
do
	PLIST="$DELIVERABLE/Info.plist"
	$PLB -c "Set :CFBundleVersion $BUILD" "$PLIST"
done
