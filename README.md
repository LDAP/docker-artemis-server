# Artemis Server Docker

## Configuration
- On first startup the container creates the default configuration. Edit to your liking.
    - The server may restart multiple times if the configuration is invalid.
- The server exposes port 8080. To publish the port to the host interface run with `-P`. To change the port edit the application-prod/dev files. And expose the new port with `-p hostport:newport` or by simply using `-p newport:8080`.
- Artemis runs in `opt/Artemis` consider this when using relative paths in .yml files.

## Volumes

|Volume                    |Description                                    |
|--------------------------|-----------------------------------------------|
|`/opt/Artemis/config`     |artemis configuration directory                |

## Environment variables

|Variable                  |Default                                        |
|--------------------------|-----------------------------------------------|
|PROFILES                  |prod,jenkins,gitlab,artemis,scheduling         |

## Development

### Build arguments

|Argument                  |Description                                    |
|--------------------------|-----------------------------------------------|
|ARTEMIS_VERSION           |Git tag or branch name                         |

### Overwrite execution WAR-file
To overwrite the used WAR-file mount `/opt/Artemis/Artemis.war` to a custom WAR-file.