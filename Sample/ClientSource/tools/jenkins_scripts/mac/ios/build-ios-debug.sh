#!/bin/bash
#This script is used to finish a ios automated compiler.

compileresult=0
cp iphonesim ../../../../samples/TestCpp/proj.ios
cd ../../../../samples
#List simulator sdks
xcodebuild -showsdks > tmp.txt

#Get sdk's numbers
sdk_num=`grep "Simulator - iOS" tmp.txt|wc -l`
grep "Simulator - iOS" tmp.txt > tmp1.txt
sed 's/Simulator - iOS [4-5].[0-9]//' tmp1.txt> tmp.txt

#Use a for circulation to build each version of sdks
cp tmp.txt $(pwd)/TestCpp/proj.ios
cd TestCpp/proj.ios
echo $sdk_num > sdk_num.txt
for((i=1;i<=$sdk_num;i++))
do
    a=$(sed -n '1p' tmp.txt)
    echo $a
    
#Build debug version
    xcodebuild -configuration Debug $a
    compileresult=$[$compileresult+$?]
    if [ $? == 0 ]; then
        var1=build/Debug-iphonesimulator
        var2=${a:(-3):3}
        var3=${var1}${var2}
        echo 'Debug-iphonesimulator'${var2} >> directory_name.txt
        mv build/Debug-iphonesimulator $var3
    fi
    sed -i '' '1d' tmp.txt
done

cd ../..
#Use a for circulation to build each version of sdks
cp tmp.txt $(pwd)/HelloCpp/proj.ios
cd HelloCpp/proj.ios
for((i=1;i<=$sdk_num;i++))
do
    a=$(sed -n '1p' tmp.txt)
    echo $a

    
#Build debug version
    xcodebuild -configuration Debug $a
    compileresult=$[$compileresult+$?]
    sed -i '' '1d' tmp.txt
done

cd ../..
#Use a for circulation to build each version of sdks
cp tmp.txt $(pwd)/HelloLua/proj.ios
cd HelloLua/proj.ios
for((i=1;i<=$sdk_num;i++))
do
    a=$(sed -n '1p' tmp.txt)
    echo $a
    
#Build debug version
    xcodebuild -configuration Debug $a
    compileresult=$[$compileresult+$?]
    sed -i '' '1d' tmp.txt
done

#return the compileresult.
cd ../../..
if [ $compileresult != 0 ]; then
    echo Error.
    echo $compilesult
#    git checkout -f
#    git clean -df -x
    exit 1
else
    echo Success.
    echo $compileresult
#    git checkout -f
#    git clean -df -x
fi