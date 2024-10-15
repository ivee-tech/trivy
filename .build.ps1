# Use the following command to build the image locally:
# versions: 0.21.0, 0.34.0, 0.41.0, 0.53.0

$tag='0.53.0'
docker pull aquasec/trivy:${tag}
docker build -t trivy:${tag} --build-arg VERSION=${tag} -f Dockerfile.ubuntu .

# Tag the image and push to docker hub:

# docker hub
$registry='docker.io'
$ns='daradu' # namespace
# ACR
$registry='ktbacr.azurecr.io'
$ns = 'tools'

$tag='0.53.0'
$image='trivy'
$img="${image}:${tag}"
docker tag ${img} ${registry}/${ns}/${img}
# for docker hub use docker login
docker login
# for ACR use az acr login
az acr login --name $registry
docker push ${registry}/${ns}/${img}


