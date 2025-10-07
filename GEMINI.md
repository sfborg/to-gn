# GEMINI.md

## Project Overview

This project is a command-line tool named `to-gn`, written in Go. Its primary function is to convert "SFGA archive" files into a format suitable for the "GNverifier" database. The tool can handle SFGA archives in various formats, including zipped archives, SQL dumps, and SQLite databases.

The project uses the `cobra` library for command-line argument parsing and `viper` for configuration management. It follows a standard Go project structure with `cmd`, `internal`, and `pkg` directories.

## Building and Running

The project includes a `Justfile`, providing a convenient way to manage common development tasks.

### Building the project

To build the project, use one of the following commands:

```bash
just build
```

### Installing the binary

To install the binary, use one of the following commands:

```bash
just install
```

### Running tests

To run the tests, use one of the following commands:

```bash
just test
```

### Creating a release

To create a release for different operating systems, use one of the following commands:

```bash
just release
```

## Development Conventions

*   **Dependency Management:** The project uses Go modules for dependency management.
*   **Code Structure:** The codebase is organized into `cmd`, `internal`, and `pkg` directories.
*   **Command-line Interface:** The `cobra` library is used to create the command-line interface.
*   **Configuration:** The `viper` library is used for configuration management.
*   **Logging:** The `slog` library is used for logging.
*   **Testing:** The `testify` library is used for assertions in tests.
