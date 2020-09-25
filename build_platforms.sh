#!/bin/bash

mkdir -p dist
mkdir -p assets
mkdir -p scripts

# Alpine platform
platform="alpine" test_platforms="alpine:latest alpine:3 alpine:3.8" ./build_and_test_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi

# Debian8 platform
platform="debian8" test_platforms="debian:8 debian:9 debian:10 ubuntu:20.04 ubuntu:16.04 ubuntu:18.04 centos:7 centos:8" ./build_and_test_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi

# CentOS7 platform
platform="centos7" test_platforms="centos:8 centos:7 debian:8 debian:9 debian:10 ubuntu:16.04 ubuntu:18.04" ./build_and_test_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi

# CentOS6 platform
platform="centos6" test_platforms="centos:6 centos:8 centos:7 debian:8 debian:9 debian:10 ubuntu:16.04 ubuntu:18.04" ./build_and_test_platform.sh
retval=$?
if [[ retval -ne 0 ]]; then
  exit $retval
fi

exit 0

