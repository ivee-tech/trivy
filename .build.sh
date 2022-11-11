# Use the following command to build the image locally:

tag='0.34.0'
docker build -t trivy:${tag} -f Dockerfile.ubuntu .

# Tag the image and push to docker hub:

tag='0.34.0'
image='trivy'
registry='docker.io'
img="${image}:${tag}"
ns='<ns>' # namespace
docker tag ${img} ${registry}/${ns}/${img}
# requires docker login
docker push ${registry}/${ns}/${img}
