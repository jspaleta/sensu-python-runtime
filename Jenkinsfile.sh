export ASSET_FILE_NAME=sensu-python-runtime_${ASSET_VERSION}_python-${PYTHON_VERSION}_${OSVERSION}_linux_amd64.tar.gz
export S3_LOCATION=s3://${S3_BUCKET}${S3_FOLDER}
export IMAGE_TAG="sensu-python-runtime:${PYTHON_VERSION}-${OSVERSION}"
export CONTAINER_NAME="sensu-python-runtime_${PYTHON_VERSION}-${OSVERSION}"
export S3_FILE_URL=https://${S3_BUCKET}.s3.amazonaws.com${S3_FOLDER}${ASSET_FILE_NAME}
export PATH=/var/lib/jenkins/.local/bin:$PATH
pip install --user awscli
docker build --build-arg "ASSET_VERSION=${ASSET_VERSION}" --build-arg "PYTHON_VERSION=${PYTHON_VERSION}" -t ${IMAGE_TAG} -f Dockerfile.${OSVERSION} .
docker run -itd --name ${CONTAINER_NAME} ${IMAGE_TAG}
docker cp ${CONTAINER_NAME}:/assets/${ASSET_FILE_NAME} .
docker rm -f ${CONTAINER_NAME}
echo "Uploading sensu asset to S3 bucket: ${S3_BUCKET}"
export SSUM=$(sha512sum ${ASSET_FILE_NAME} | cut -d ' ' -f 1)
ls -ltrh
aws s3 cp ${ASSET_FILE_NAME} ${S3_LOCATION} --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
rm -rf ${ASSET_FILE_NAME}
echo ${S3_FILE_URL}