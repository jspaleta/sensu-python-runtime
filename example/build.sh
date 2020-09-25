#/usr/bin/env sh

echo "Use pip to install needed modules into the lib/ directory of the python asset"
echo "pip install --target $(pwd)/python_asset/lib bofhexcuse"
pip install --target $(pwd)/python_asset/lib bofhexcuse
echo "create asset tarball"
tar cvzf example-python-asset.tar.gz -C python_asset ./

sha512sum example-python-asset.tar.gz > sha512sum.txt
