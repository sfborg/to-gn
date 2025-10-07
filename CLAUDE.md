# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`to-gn` is a CLI tool that converts SFGA (Simple File-based Global Archive) data into entries for the GNverifier (Global Names Verifier) PostgreSQL database. It processes taxonomic name data from various data sources and imports them into a standardized database schema.

## Build and Development Commands

### Using Just (preferred)
```bash
just deps              # Download Go dependencies
just tools            # Install required tools from tools.go
just build            # Build development binary with version info
just buildrel         # Build release binary (stripped, optimized)
just install          # Install to $GOPATH/bin with version info
just test             # Run tests with coverage
just coverage         # Run tests and show coverage report
just release          # Build cross-platform release binaries (Linux, macOS, Windows)
just version          # Show current version from git tags
```

### Using Make (alternative)
```bash
make deps             # Download dependencies
make tools            # Install tools
make build            # Build development binary
make buildrel         # Build release binary
make install          # Install binary
make test             # Run tests
make coverage         # Coverage report
make release          # Build all platform binaries
```

### Running Tests
```bash
# Run all tests with coverage
just test
# Or: go test -count=1 -p 1 -shuffle=on -coverprofile=coverage.txt -covermode=atomic ./...

# Single package test
go test ./pkg/togn/

# With verbose output
go test -v ./internal/io/sfio/
```

## Configuration

### Config File
On first run, `to-gn` creates a config file at `~/.config/to-gn.yaml` (or user's config directory). See `cmd/to-gn.yaml` for default settings.

### Environment Variables
Configuration can be set via environment variables (useful with direnv):
- `TO_GN_DB_DATABASE` - Database name (default: "gnames")
- `TO_GN_DB_HOST` - Database host (default: "0.0.0.0")
- `TO_GN_DB_USER` - Database user (default: "postgres")
- `TO_GN_DB_PASS` - Database password (default: "postgres")
- `TO_GN_JOBS_NUM` - Number of concurrent jobs (default: 4)
- `TO_GN_WITH_FLAT_CLASSIFICATION` - Prefer flat classification over parent/child

See `.envrc.example` for a direnv template.

### Command-Line Flags
- `-s, --source <id>` - Data source ID (required, or extracted from filename/archive)
- `-r, --source-release-date <date>` - Data source release date
- `-j, --jobs-number <n>` - Number of concurrent jobs
- `-f, --flat-classification` - Prefer flat classification over hierarchical
- `-V, --version` - Show version

## Architecture

### Core Components

**Main Flow (cmd/root.go:64-118)**
1. Parse flags and configuration
2. Initialize SFGA reader (`sfio`)
3. Initialize GN database writer (`gnio`)
4. Create ToGN orchestrator
5. Execute export pipeline

**Three-Layer Architecture:**

1. **SF Layer** (`pkg/sf/`, `internal/io/sfio/`)
   - Reads SFGA archives (zip, SQL dump, or SQLite)
   - Extracts taxonomic names, vernacular names, hierarchies
   - Uses gnparser pool for parallel name parsing
   - Handles parent/child vs flat classification

2. **GN Layer** (`pkg/gn/`, `internal/io/gnio/`)
   - Manages PostgreSQL connection pool (pgx/v5)
   - Batch inserts for performance (63K batch size)
   - Exports: data sources, canonical names, name strings, vernacular names

3. **ToGN Orchestrator** (`pkg/togn/`)
   - Coordinates SF → GN data flow
   - Export pipeline (togn.go:35-72):
     1. Extract SFGA archive
     2. Export name strings
     3. Export name string indices
     4. Export vernacular strings
     5. Export vernacular indices
     6. Export data source metadata

### Key Packages

- `pkg/config/` - Configuration management with functional options pattern
- `pkg/ds/` - Data source metadata and mapping
- `pkg/code/` - Exit codes and error handling
- `internal/io/` - I/O implementations (sfio for SFGA, gnio for GN database)

### Important Patterns

**Parser Pool:** sfio uses a pool of gnparser instances (`gnpPool`) for concurrent name parsing (sfio.go:17,28)

**Hierarchy Handling:** sfio maintains a map of hierarchical nodes (`hierarchy map[string]*hNode`) to build classification from parent/child relationships or use flat classification when available (sfio.go:21)

**Batch Processing:** Database writes use 63K batch size to stay under PostgreSQL's 64K parameter limit (config.go:132)

**Version Compatibility:** Requires SFGA schema version >= v0.3.24 (config.go:10, sfio.go:48-51)

## Data Sources

The tool expects a Data Source ID which maps to entries in the GNverifier database. The ID can be:
- Provided via `-s` flag
- Embedded in the SFGA archive
- Extracted from filename (e.g., `001-sfga-col-2025-01-24.zip`)

Data source metadata is defined in `pkg/ds/`.

## Testing

Test files use standard Go conventions (`*_test.go`). Test data is in `testdata/`:
- `182-gymno.*` - Gymnosperm test dataset (SQL, SQLite, tar.gz formats)
- `ioc-bird.sqlite.zip` - IOC bird names test dataset

## Database Schema

The tool writes to a PostgreSQL database (default: "gnames") with tables for:
- Data sources and their releases
- Canonical name strings (parsed scientific names)
- Name strings (with indices per data source)
- Vernacular names (common names) and their indices

Connection uses pgx/v5 connection pool for performance.

## Local Development Setup

1. Clone repo and navigate to directory
2. Set up database credentials in `.envrc` (copy from `.envrc.example`) or `~/.config/to-gn.yaml`
3. Run `just deps && just tools` or `make deps && make tools`
4. Build with `just build` or `make build`
5. Test with sample data: `./to-gn testdata/182-gymno.sqlite`
