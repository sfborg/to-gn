# to-gn

Converts SFGA archive to entries for the GNverifier database.

## Install

Copy from the [latest release] a compressed file for your operating system,
extract `to-gn` file and place it somewhere in your `PATH`.

## Usage

Use SFGA file or URL to convert it to GNverifier data:

```bash
# create configuration file (and see the version of to-gn)
to-gn -V
# edit config file to change gnames database requisites
# then run
# zipped version of an sfga archive
to-gn an-sfga-archive.zip
# -s option sets data-source id for GNverifier. It should correspond to
# data souorces ids at https://verifier.globalnames.org/data_sources
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

One SFGA file contains data from a single data-source.

[latest release]: https://github.com/sfborg/to-gn/releases/latest
