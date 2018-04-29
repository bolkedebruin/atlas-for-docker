# Docker Apache Atlas with Berkley DB plus zookeeper image

## Building the image
```
docker build -f Dockerfile -t atlas-for-docker .
```

## Configuring the image

T.b.d.

## Running the image
Port 21000 is used for the Web Interface / API. Password is admin/admin

```
docker run --rm -p 21000:21000 --name atlas bolkedebruin/atlas-for-docker
```

