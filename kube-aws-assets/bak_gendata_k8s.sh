#!/bin/sh
#save generated data for future operate with cluster
if [ -z $JOB_NAME ]
then
JOB_NAME=master
fi

if [ -z $BUILD_NUMBER ]
then
BUILD_NUMBER=`date +%y%m%d_%H%M`
fi

mkdir -p "/opt/OPSWP/$JOB_NAME/$BUILD_NUMBER"
cp -r ./credentials /opt/OPSWP/$JOB_NAME/$BUILD_NUMBER
cp -r ./userdata /opt/OPSWP/$JOB_NAME/$BUILD_NUMBER
cp -r ./stack-templates /opt/OPSWP/$JOB_NAME/$BUILD_NUMBER
cp -r ./kubeconfig /opt/OPSWP/$JOB_NAME/$BUILD_NUMBER
cp -r ./cluster.yaml /opt/OPSWP/$JOB_NAME/$BUILD_NUMBER