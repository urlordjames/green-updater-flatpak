#!/bin/sh
flatpak-builder --force-clean --user --install-deps-from=flathub --repo=repo --install builddir io.github.urlordjames.GreenUpdater.json
