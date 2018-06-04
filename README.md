# Standalone Docker Apache Atlas with Berkeley DB.

It builds with the `embedded-hbase-solr` profile, but hbase is not enabled. Zookeeper is embedded in the image.

## Building the image
```
docker build -f Dockerfile -t atlas-for-docker .
```

## Configuring the image

No config options present as of yet.

## Running the image
Port 21000 is used for the Web Interface / API. Password is admin/admin

```
docker run --rm -p 21000:21000 --name atlas bolkedebruin/atlas-for-docker
```

