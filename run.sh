docker build -t layer-builder .
docker create --name temp-container layer-builder
docker cp temp-container:/opt/lambda-layer.zip ./build/lambda-layer.zip
docker rm temp-container
