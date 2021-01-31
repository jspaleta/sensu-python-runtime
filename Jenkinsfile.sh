ASSET_FILE_NAME=sensu-python-runtime_${ASSET_VERSION}_python-${PYTHON_VERSION}_${OSVERSION}_linux_amd64.tar.gz
S3_LOCATION=s3://${S3_BUCKET}${S3_FOLDER}
OSDISTRO=$(printf '%s' "$OSVERSION" | sed 's/[0-9]*//g')
export S3_FILE_URL=https://${S3_BUCKET}.s3.amazonaws.com${S3_FOLDER}${ASSET_FILE_NAME}
export OSDISTRO=$OSDISTRO
pip install --user awscli
export PATH=/var/lib/jenkins/.local/bin:$PATH
docker build --no-cache --build-arg "ASSET_VERSION=${ASSET_VERSION}" --build-arg "PYTHON_VERSION=${PYTHON_VERSION}" -t sensu-python-runtime:${PYTHON_VERSION}-${OSVERSION} -f Dockerfile.${OSVERSION} .
docker run -itd --name sensu-python-runtime_${PYTHON_VERSION}-${OSVERSION} sensu-python-runtime:${PYTHON_VERSION}-${OSVERSION}
docker cp sensu-python-runtime_${PYTHON_VERSION}-${OSVERSION}:/assets/${ASSET_FILE_NAME} .
docker rm -f sensu-python-runtime_${PYTHON_VERSION}-${OSVERSION}
echo "Uploading sensu asset to S3 bucket: ${S3_BUCKET}"
SSUM=$(sha512sum ${ASSET_FILE_NAME} | cut -d ' ' -f 1)
export SSUM=$SSUM
aws s3 cp ${ASSET_FILE_NAME} ${S3_LOCATION} --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
ls -ltr
rm -rf ${ASSET_FILE_NAME}
echo $(envsubst < py3-runtime/asset.yml) > py3-runtime/asset.yml
cd py3-runtime
./build.sh
cd ..