#!/usr/bin/env python

import sys

print("Example using bofhexcuse python module, packaged with this asset")
print("\nHere's the current module search path")
print(sys.path) 
print("\nCalling bofhexcuse.bofh_excuse:")
print ("This should return without error when called using wrapper script in asset's bin/")
print ("This should return with error when called directly from asset's libexec/")
import bofhexcuse
print( bofhexcuse.bofh_excuse()[0])


