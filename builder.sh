#!/bin/sh
mkdir /images
cd /images

if [ -n "$REGISTRY_USER" && -n "$REGISTRY_PASS" ]; then
	# Login to registry
	docker login -u "$REGISTRY_USER" -p "$REGISTRY_PASS" "$REGISTRY_HOST"
fi

rebuild_image() {
	# Obtain image name
	name=$(basename $1)
	echo Building $name

	docker build --pull ${REGISTRY_HOST:+--push} -t "${REGISTRY_HOST:+$REGISTRY_HOST/}$name" "$1"
}

for dir in ./*/ ; do
	rebuild_image $dir
done
