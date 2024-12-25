#!/bin/python3

import json
import os

def run(cmd):
	result = os.system(cmd)
	exit_code = os.waitstatus_to_exitcode(result)
	if exit_code != 0:
		exit(exit_code)

with open("io.github.urlordjames.GreenUpdater.json", "r") as f:
	parsed = json.load(f)
	commit = parsed["modules"][0]["sources"][0]["commit"]

run("git clone 'https://github.com/urlordjames/green-updater.git'")
run(f"cd green-updater && git checkout {commit} && cd ..")
run("git clone 'https://github.com/flatpak/flatpak-builder-tools.git'")
run("cd flatpak-builder-tools && git checkout a1eb29c5f3038413ffafd4fea34e62c361c109ad && cd ..")
run("python3 flatpak-builder-tools/cargo/flatpak-cargo-generator.py green-updater/Cargo.lock -o cargo-source.json")
run("flatpak-builder --user --force-clean --disable-rofiles-fuse --install-deps-from=flathub --gpg-sign=urlordjames --repo=repo builddir io.github.urlordjames.GreenUpdater.json")
