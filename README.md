# Artemis Server Docker

## Configuration
- On first startup the container creates the default configuration. Edit to your liking.
    - The server may restart multiple times if the configuration is invalid.

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