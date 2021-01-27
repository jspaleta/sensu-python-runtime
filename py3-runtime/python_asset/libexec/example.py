#!/usr/bin/env python

import sys
import requests

print("Example using requests python module, packaged with this asset")
print("\nHere's the current module search path")
print(sys.path) 
print("\nCalling requests.__version__:")
print ("This should return without error when called using wrapper script in asset's bin/")
print ("This should return with error when called directly from asset's libexec/")

print(requests.__version__)
