# Sensu Go Python Runtime Assets
[![Build Status](https://travis-ci.org/jspaleta/sensu-python-runtime.svg?branch=master)](https://travis-ci.org/jspaleta/sensu-python-runtime)

This project provides [Sensu Go Assets][sensu-assets] containing portable Python
runtimes (for various platforms), based on the excellent [pyenv project][pyenv]. In practice, this Python runtime asset should allow
Python-based scripts (e.g. [Sensu Community plugins][sensu-plugins]) to be
packaged as separate assets containing Python scripts and any corresponding Python module
dependencies. In this way, a single shared Python runtime may be delivered to
systems running the new Sensu Go Agent via the new Sensu's new Asset framework
(i.e. avoiding solutions that would require a Python runtime to be redundantly
packaged with every python-based plugin).


[sensu-assets]: https://docs.sensu.io/sensu-go/latest/reference/assets/
[pyenv]: https://github.com/pyenv/pyenv
[sensu-plugins]: https://github.com/sensu-plugins/

## Platform Coverage:
 Currently this repository only supports a subset of Linux distribution by making use of Docker containers to build and test.
 If you would like extend the coverage, please take a look at the travisCI integration and test build scripts. We're happy to take pull requests that extending the platform coverage. Here's the current platform matrix that we are testing for as of the 0.1 release:

| Asset Platform | Tested Operating Systems Docker Images |
|:---------------|:-------------------------|
|  alpine  (based on alpine:3.8)   | Alpine(3, 3.8, latest)                                      |
|  centos6 (based on centos:6)     | Centos(6, 7), Debian(8, 9, 10), Ubuntu(20.04, 16.04, 18.04  |
|  centos7  (based on centos:7)     | Centos(7), Debian(8, 9, 10), Ubuntu(20.04, 16.04, 18.04     |
|  debian8  (based on debian:8)     | Debian(8, 9, 10), Ubuntu(14.04, 16.04, 18.04), Centos(7,8)    |

## OpenSSL Cert Dir
Please note that when using the Python runtime asset built on a target OS that is different from the build platform, you may need to explicitly set the SSL_CERT_DIR environment variable to match the target OS filesystem.  Example: CentOS configures it libssl libraries to look for certs by default in `/etc/pki/tls/certs` and Debian/Ubuntu use `/usr/lib/ssl/certs`. The CentOS runtime asset when used on a Debian system would require the use of SSL_CERT_DIR override in the check command to correctly set the cert path to `/usr/lib/ssl/certs`


## Instructions

Please note the following instructions:

1. Use a Docker container to install `pyenv`, build a Python, and generate
   a local_build Sensu Go Asset.

   ```
   $ docker build --build-arg "PYTHON_VERSION=3.6.11" -t sensu-python-runtime:3.6.11-alpine -f Dockerfile.alpine .
   $ docker build --build-arg "PYTHON_VERSION=3.6.11" -t sensu-python-runtime:3.6.11-debian8 -f Dockerfile.debian8 .
   ```

2. Extract your new sensu-python asset, and get the SHA-512 hash for your
   Sensu asset!

   ```
   $ mkdir assets
   $ docker run -v "$PWD/assets:/assets" sensu-python-runtime:3.6.11-debian8 cp /assets/sensu-python-runtime_3.6.11_debian8_linux_amd64.tar.gz /assets/
   $ shasum -a 512 assets/sensu-python-runtime_3.6.11_debian8_linux_amd64.tar.gz
   ```

3. Put that asset somewhere that your Sensu agent can fetch it. Perhaps add it to the Bonsai asset index!



3. Create an asset resource in Sensu Go.

   First, create a configuration file called `sensu-python-runtime-3.6.11-debian.json` with
   the following contents:

   ```
   {
     "type": "Asset",
     "api_version": "core/v2",
     "metadata": {
       "name": "sensu-python-runtime-3.6.11-debian",
       "namespace": "default",
       "labels": {},
       "annotations": {}
     },
     "spec": {
       "url": "http://your-asset-server-here/assets/sensu-python-runtime-3.6.11-debian8.tar.gz",
       "sha512": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
       "filters": [
         "entity.system.os == 'linux'",
         "entity.system.arch == 'amd64'",
         "entity.system.platform_family == 'debian'"
       ]
     }
   }
   ```

   Then create the asset via:

   ```
   $ sensuctl create -f sensu-python-runtime-3.6.11-debian.json
   ```

4. Create a second asset containing a Python script.

   To run a simple test using the Python runtime asset, create another asset
   called `helloworld-v0.1.tar.gz` with a simple Python script at
   `bin/helloworld.py`; e.g.:

   ```python
   #!/usr/bin/env python
   from datetime import datetime

   now = datetime.now()

   current_time = now.strftime("%H:%M:%S")
   print("Hellow world! The current Time is ", current_time)

   ```

   _NOTE: this is a simple "hello world" example, but it shows that we have
   support for basic modules!_

   Compress this file into a g-zipped tarball and register this asset with
   Sensu, and then you're all ready to run some tests!

5. Create a check resource in Sensu Go.

   First, create a configuration file called `helloworld.json` with
   the following contents:

   ```
   {
     "type": "CheckConfig",
     "api_version": "core/v2",
     "metadata": {
       "name": "helloworld",
       "namespace": "default",
       "labels": {},
       "annotations": {}
     },
     "spec": {
       "command": "helloworld.py",
       "runtime_assets": ["sensu-python-runtime-3.6.11-debian", "helloworld-v0.1"],
       "publish": true,
       "interval": 10,
       "subscriptions": ["docker"]
     }
   }
   ```

   Then create the asset via:

   ```
   $ sensuctl create -f helloworld.json
   ```

   At this point, the `sensu-backend` should begin publishing your check
   request. Any `sensu-agent` member of the "docker" subscription should
   receive the request, fetch the Python runtime and helloworld assets,
   unpack them, and successfully execute the `helloworld.py` command by
   resolving the Python shebang (`#!/usr/bin/env python`) to the Python runtime
   on the Sensu agent `$PATH`.:wq

## Building Python Assets that need additional modules
The Python runtime includes a basic set of standard python modules. If you want to use a python script that requires additional modules, you can package those additional modules with your script in an asset. However you will need to use a wrapper script that set the python module search path correctly.  Please take a look at [packaging python modules](docs/building_assets.md) for detailed instructions on steps to take.
   
