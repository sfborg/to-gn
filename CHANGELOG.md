# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v0.2.0] - 2025-01-30 Thu

Add: botanical code to parse hierachy's elements to fix parsing of
     names like `Aus (Linnaeus` and return Aus instead of Linnaeus.
Add: (origin/main, origin/HEAD) typo.
Add: fix hierarchy for root elements.
Add: fix links for IPNI and MycoBank.
Add: fix nil crash in get-name-indices.go.
Add: change eol outlink to name_id.
Add: 
Add: [#13] use coldp-based SFGA for import.
Fix: nil crash in get_name_indices.go.

## [v0.1.0] - 2024-10-09 Wed

Add: outlinkID to import.
Add [#10]: data-source metadata.
Add [#9]: name-string indices.
Add [#8]: vernacular string incides.
Add [#7]: name-strings with parsed data.
Add [#6]: export vernacular strings.
Add [#5]: export scientific name strings.
Add [#4]: connect to SFGA database.
Add [#3]: connect to GNverifier database.

## [v0.0.0] - 2024-06-13 Thu

Add [#2]: configuration file.
Add [#1]: skeleton of the program.
Add: initial commit

## Footnotes

This document follows [changelog guidelines]

[v0.2.0]: https://github.com/sfborg/to-gn/tree/v0.1.0...v0.2.0
[v0.1.0]: https://github.com/sfborg/to-gn/tree/v0.0.0...v0.1.0
[v0.0.0]: https://github.com/sfborg/to-gn/tree/v0.0.0
[#20]: https://github.com/sfborg/to-gn/issues/20
[#19]: https://github.com/sfborg/to-gn/issues/19
[#18]: https://github.com/sfborg/to-gn/issues/18
[#17]: https://github.com/sfborg/to-gn/issues/17
[#16]: https://github.com/sfborg/to-gn/issues/16
[#15]: https://github.com/sfborg/to-gn/issues/15
[#14]: https://github.com/sfborg/to-gn/issues/14
[#13]: https://github.com/sfborg/to-gn/issues/13
[#12]: https://github.com/sfborg/to-gn/issues/12
[#11]: https://github.com/sfborg/to-gn/issues/11
[#10]: https://github.com/sfborg/to-gn/issues/10
[#9]: https://github.com/sfborg/to-gn/issues/9
[#8]: https://github.com/sfborg/to-gn/issues/8
[#7]: https://github.com/sfborg/to-gn/issues/7
[#6]: https://github.com/sfborg/to-gn/issues/6
[#5]: https://github.com/sfborg/to-gn/issues/5
[#4]: https://github.com/sfborg/to-gn/issues/4
[#3]: https://github.com/sfborg/to-gn/issues/3
[#2]: https://github.com/sfborg/to-gn/issues/2
[#1]: https://github.com/sfborg/to-gn/issues/1
[changelog guidelines]: https://keepachangelog.com/en/1.0.0/
