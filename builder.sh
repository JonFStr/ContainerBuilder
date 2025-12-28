#!/bin/sh
mkdir -p /images
cd /images

if [ -n "$REGISTRY_USER" -a -n "$REGISTRY_PASS" ]
then
	# Login to registry
	docker login -u "$REGISTRY_USER" -p "$REGISTRY_PASS" "$REGISTRY_HOST"
fi

rebuild_image() {
	# Obtain image name
	name=$(basename "$1")

	if [ -d "$1/.git" ]; then
		echo Found git repositry, performing pull…
		git -C "$1" pull --rebase
	fi

	args_file="$(realpath "$1")/../${name}.args"
	build_args=""
	if [ -f "$args_file" ]; then
		echo Found build arguments in "$args_file", loading…
		build_args="$(cat "$args_file" | tr -s '\n' ' ')"
	fi

	echo Building ${name}…
	docker build --pull ${REGISTRY_HOST:+--push} -t "${REGISTRY_HOST:+$REGISTRY_HOST/}$name" ${build_args} "$1"
}

for dir in ./*/ ; do
	rebuild_image $dir
done
