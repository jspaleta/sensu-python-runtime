#!/bin/sh
set -e
echo "Test Script:"
echo "  Asset Platform:  ${platform}"
echo "  Target Platform: ${test_platform}"
echo "  Asset Tarball:   ${asset_filename}"
if [ -z "$asset_filename" ]; then
  echo "Asset is empty"
  exit 1
fi
mkdir -p /build
cd /build
tar xzf /dist/$asset_filename
[ "$(LD_LIBRARY_PATH="/build/lib:$LD_LIBRARY_PATH" /build/bin/python --version)" = "Python ${PYTHON_VERSION}" ]
LD_LIBRARY_PATH="/build/lib:$LD_LIBRARY_PATH" /build/bin/python /tests/uuid_test.py
LD_LIBRARY_PATH="/build/lib:$LD_LIBRARY_PATH" /build/bin/python /tests/ssl_test.py
LD_LIBRARY_PATH="/build/lib:$LD_LIBRARY_PATH" /build/bin/python /tests/lzma_test.py
LD_LIBRARY_PATH="/build/lib:$LD_LIBRARY_PATH" /build/bin/python /tests/sqlite_test.py
LD_LIBRARY_PATH="/build/lib:$LD_LIBRARY_PATH" /build/bin/python /tests/module_search_path.py
