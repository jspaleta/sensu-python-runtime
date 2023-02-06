#!/bin/bash

mkdir -p dist
mkdir -p assets
mkdir -p scripts

# Alpine platform
platform="alpine" test_platforms="alpine:latest alpine:3 alpine:3.16" ./build_and_test_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi

# Debian8 platform
platform="debian10" test_platforms="debian:10 debian:11 ubuntu:20.04 ubuntu:18.04" ./build_and_test_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi

# CentOS7 platform
platform="centos7" test_platforms=" almalinux:8 centos:7 almalinux:9" ./build_and_test_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi

exit 0

