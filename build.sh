#!/bin/sh
flatpak-cargo-vendor $CARGO_LOCK -o cargo-source.json
./common-build.sh
