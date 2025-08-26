# Use the following command to build the image locally:
# versions: 0.21.0, 0.34.0, 0.41.0, 0.53.0, 0.59.0

$tag='0.64.1' # '0.59.0'
docker pull aquasec/trivy:${tag}
docker build -t trivy:${tag} --build-arg VERSION=${tag} -f Dockerfile.ubuntu .

# Tag the image and push to docker hub:

# docker hub
$registry='docker.io'
$ns='daradu' # namespace
# ACR
$registry='ktbacr.azurecr.io'
$ns = 'tools'

$tag='0.59.0'
$image='trivy'
$img="${image}:${tag}"
docker tag ${img} ${registry}/${ns}/${img}
# for docker hub use docker login
docker login
# for ACR use az acr login
az acr login --name $registry
docker push ${registry}/${ns}/${img}


# pulling trivy-db as OCI artifact
# this fails with "unsupported media type application/vnd.oci.empty.v1+json"
# docker pull aquasec/trivy-db:latest
# rm -rf $TRIVY_TEMP_DIR
# older version
# docker pull aquasec/trivy-db:v1-2023021412

docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v C:/Data/trivy/trivy-db:/app/trivy-db trivy:0.59.0 image --cache-dir /app/trivy-db --download-db-only
docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v C:/Data/trivy/trivy-db:/app/trivy-db trivy:0.59.0 sh
trivy --cache-dir /app/trivy-db image --download-db-only
tar -cf /app/trivy-db/db.tar.gz -C /app/trivy-db/db metadata.json trivy.db

$acrName='ktbacr'
$registry="$acrName.azurecr.io"
$repo='trivy/trivy-db'
$tag='2'
$repo='trivy/trivy-java-db'
$tag='1'
$image="$($registry)/$($repo):$($tag)"
az login --tenant $env:FDPO_TENANT_ID
az acr login -n $registry  

oras pull ghcr.io/aquasecurity/trivy-db:2
oras pull ghcr.io/aquasecurity/trivy-java-db:1

$TRIVY_TEMP_DIR = 'C:\Data\trivy\trivy-java-db'
cd $TRIVY_TEMP_DIR
$artifactPath="./db.tar.gz"
$mediaType = 'application/vnd.aquasec.trivy.db.layer.v1.tar+gzip'
$artifactPath = './javadb.tar.gz'
$mediaType = 'application/vnd.aquasec.trivy.javadb.layer.v1.tar+gzip'
oras push $image "$($artifactPath):$($mediaType)"

# pull the artifact
$pullPath = "./2"
oras pull $image -o $pullPath

# delete the artifact
# oras manifest delete $image

ktbacr.azurecr.io/trivy/trivy-db:2
ktbacr.azurecr.io/trivy/trivy-java-db:1

# TODO: add config checks DB

