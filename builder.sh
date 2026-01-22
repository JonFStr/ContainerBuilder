#!/bin/sh
mkdir -p /images
cd /images

if [ -n "$REGISTRY_USER" -a -n "$REGISTRY_PASS" ]
then
	# Login to registry
	docker login -u "$REGISTRY_USER" -p "$REGISTRY_PASS" "$REGISTRY_HOST"
fi

if [ -z "$GIT_AUTHOR_NAME" -o -z "$GIT_AUTHOR_EMAIL" ]
then
	export GIT_AUTHOR_NAME="Automated Container Builder"
	export GIT_AUTHOR_EMAIL="builder@registry.local"
fi

rebuild_image() {
	# Obtain image name
	name=$(basename "$1")

	if [ -d "$1/.git" ]; then
		echo Found git repositry, performing pull…
		git -c user.name="$GIT_AUTHOR_NAME" -c user.email="$GIT_AUTHOR_EMAIL" -C "$1" pull --rebase
	fi

	args_file="$(realpath "$1")/../${name}.args.sh"
	build_args=""
	if [ -f "$args_file" ]; then
		echo Found build arguments in "$args_file", loading…
		build_args="$(cd "$1" && sh "$args_file" | tr -s '\n' ' ')"
	fi

	echo Building ${name}…
	docker build --pull ${REGISTRY_HOST:+--push} -t "${REGISTRY_HOST:+$REGISTRY_HOST/}$name" ${build_args} "$1"
}

for dir in ./*/ ; do
	rebuild_image $dir
done
