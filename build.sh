flatpak-cargo-vendor $CARGO_LOCK -o cargo-source.json
flatpak-builder --force-clean --user --install-deps-from=flathub --repo=repo --install builddir io.github.urlordjames.GreenUpdater.json
