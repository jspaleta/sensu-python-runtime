## Building Python Sensu Assets

### Asset Structure

### libexec/
This directory should be populated with the actual python script that you want to run

### bin/
This directly should be populated with symlinks to the share/wrapper script, one for each executable in libexec

### share/
This has additional utilities to make things work as expected. Primarily this directory has the wrapper script used to populate the PYTHONPATH variable so that it includes the lib/ directory relative to the asset.

### lib/
This is where you will install needed python modules using `pip install --target <path>`
The python runtime asset includes a pip that can be used during the build process.
So best practise is to build python assets using the python runtime asset version you want to work with.


## Example
Look at the example/ for an example of the python-asset following this structure.
