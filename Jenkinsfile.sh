ASSET_FILE_NAME=sensu-python-runtime_${ASSET_VERSION}_python-${PYTHON_VERSION}_${OSVERSION}_linux_amd64.tar.gz
S3_LOCATION=s3://${S3_BUCKET}${S3_FOLDER}
pip install --user awscli
export PATH=/var/lib/jenkins/.local/bin:$PATH
docker build --build-arg "ASSET_VERSION=${ASSET_VERSION}" --build-arg "PYTHON_VERSION=${PYTHON_VERSION}" -t sensu-python-runtime:${PYTHON_VERSION}-${OSVERSION} -f Dockerfile.${OSVERSION} .
docker run -itd --name sensu-python-runtime_${PYTHON_VERSION}-${OSVERSION} sensu-python-runtime:${PYTHON_VERSION}-${OSVERSION}
docker cp sensu-python-runtime_${PYTHON_VERSION}-${OSVERSION}:/assets/${ASSET_FILE_NAME} .
docker rm -f sensu-python-runtime_${PYTHON_VERSION}-${OSVERSION}
echo "Uploading archive to S3"
SSUM=$(sha512sum ${ASSET_FILE_NAME} | cut -d ' ' -f 1)
export SSUM=$SSUM
aws s3 cp ${ASSET_FILE_NAME} ${S3_LOCATION}
export S3_FILE_URL=https://${S3_BUCKET}.s3.amazonaws.com${S3_FOLDER}${ASSET_FILE_NAME}
rm -rf ${ASSET_FILE_NAME}
echo $(envsubst < sensu-python-runtime-configuration-template.json) > sensu-python-runtime-${PYTHON_VERSION}-${OSVERSION}.json
