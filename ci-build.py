#!/bin/python3

import json
import os

with open("io.github.urlordjames.GreenUpdater.json", "r") as f:
	parsed = json.load(f)
	commit = parsed["modules"][0]["sources"][0]["commit"]

os.system("git clone 'https://github.com/urlordjames/green-updater.git'")
os.system(f"cd green-updater && git checkout {commit} && cd ..")
os.system("flatpak-cargo-vendor green-updater/Cargo.lock -o cargo-source.json")
os.system("./common-build.sh")
