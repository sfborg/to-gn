# to-gn

Converts SFGA archive to entries inside GNverifier database.

## Install

Copy from the [latest release] a compressed file for your operating system,
extract `from-dwca` file and place it somewhere in your `PATH`.

## Usage

Use DwCA file or URL to convert it to sqlite SQL dump:

```bash
# create configuration file
to-gn -V
# edit file to change gnames database requisites
# then run
# zipped version of an sfga archive
to-gn an-sfga-archive.zip
# or SQL dump of the archive
to-gn an-sfga-archive.sql
# or SQLite database directly
to-gn an-sfga-archive.sqlite
```

In case if data-source ID is not provided in the archive, it can be received
in several ways.

1. From the file name (data-source_id should be at the start of the
file name (e.g. 001-sfga-col-2025-01-24.zip)

2. given in as a parameter:

```bash
to-gn -s 1 
to-gn --source 1
# to create new entry the parameter must be 0
to-gn -s 0
```

If file contains multiple data-sources, and does not contain data-sources ids,
then whold database will be destroyed and data-source IDs will be given
automatically.

[latest release]: https://github.com/sfborg/to-gn/releases/latest
