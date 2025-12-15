# ContainerBuilder
These are some small scripts which rebuild all docker images in subdirectories of the `images` directory.

Running these in a docker container updates and pushes images to a configured registry.

This allows for making simple changes to official docker images and still keeping these up-to-date automatically.

# Setup
The script attempts to run `docker build` in all subdirectories of the `images` directory and uses the directory name as tag.

Therefore, to add a new image, simply create a new subdirectory of `images` and put an appropriate `Dockerfile` (and additional resources) inside.

## Configuration
The schedule of rebuilding images is specified via cron (refer e.g. to [crontab.guru](https://crontab.guru/) for configuration.

Place a file named `crontab` in the project root or use the provided example:

```sh
cp crontab.dist crontab
```

The following environment variables can be used to configure the script:

| Variable        | Description                                                                    |
|-----------------|--------------------------------------------------------------------------------|
| `REGISTRY_HOST` | Domain of the registry to publish images to. If empty, will not perform a push |
| `REGISTRY_USER` | Username to authenticate against the given registry.                           |
| `REGISTRY_PASS  | Password to authenticate against the given registry.                           |

## Execution
A sample `docker-compose.yml` is provided in this repository.
