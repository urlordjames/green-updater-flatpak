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
run("cd flatpak-builder-tools && git checkout 338ce9c6512d49d98ae9a508d219ffe19b5144e8 && cd ..")
run("python3 flatpak-builder-tools/cargo/flatpak-cargo-generator.py green-updater/Cargo.lock -o cargo-source.json")
run("flatpak-builder --force-clean --disable-rofiles-fuse --install-deps-from=flathub --repo=repo --install builddir io.github.urlordjames.GreenUpdater.json")
