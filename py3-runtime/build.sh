#!/usr/bin/env sh

echo "Use pip to install needed modules into the lib/ directory of the python asset"
echo "pip install --target $(pwd)/python_asset/lib -r requirements.txt"
pip install -t $(pwd)/python_asset/lib -r requirements.txt
echo "create asset tarball"
tar cvzf $(pwd)-python-asset.tar.gz -C python_asset ./

sha512sum $(pwd)-python-asset.tar.gz > sha512sum.txt
