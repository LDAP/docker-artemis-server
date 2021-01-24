# Artemis Server Docker

For usage refer to [LDAP/docker-compose-artemis](https://github.com/LDAP/docker-compose-artemis).

## Configuration
- On first startup the container creates the default configuration. Edit to your liking.
    - The server may restart multiple times if the configuration is invalid.
- The server exposes port 8080. To publish the port to the host interface run with `-P`. To change the port edit the application-prod/dev files. And expose the new port with `-p hostport:newport` or by simply using `-p newport:8080`.
- Artemis runs in `opt/Artemis` consider this when using relative paths in .yml files.

## Volumes

|Volume                    |Description                                    |
|--------------------------|-----------------------------------------------|
|`/opt/Artemis/config`     |Artemis configuration directory                |
|`/opt/Artemis/data`       |Artemis data directory                         |

→ Set the Artemis data directory in the application-artemis.yml! The Artemis user does not have any permissions outside of `config` and `data`.

application-artemis.yml
```YAML
...
artemis:
    repo-clone-path: data/repos
    repo-download-clone-path: data/repos-download
...
```
application.yml
```YAML
artemis:
    ...
    file-upload-path: data/uploads
    submission-export-path: data/exports
...
```

## Environment variables

|Variable                  |Description                                                                            |
|--------------------------|---------------------------------------------------------------------------------------|
|PROFILES                  |Spring profiles. Default: prod,jenkins,gitlab,artemis,scheduling                       |
|WAIT_FOR                  |Comma separated list of host:port. Server gets started after those ports are available.|

## Building

### Build arguments

|Argument                  |Description                                    |
|--------------------------|-----------------------------------------------|
|ARTEMIS_VERSION           |Git tag or branch name, default: develop       |
