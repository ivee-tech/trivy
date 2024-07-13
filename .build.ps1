# Use the following command to build the image locally:
# versions: 0.21.0, 0.34.0, 0.41.0, 0.53.0

$tag='0.53.0'
docker pull aquasec/trivy:${tag}
docker build -t trivy:${tag} --build-arg VERSION=${tag} -f Dockerfile.ubuntu .

# Tag the image and push to docker hub:

$tag='0.53.0'
$image='trivy'
$registry='docker.io'
$img="${image}:${tag}"
$ns='daradu' # namespace
docker tag ${img} ${registry}/${ns}/${img}
# requires docker login
docker push ${registry}/${ns}/${img}
