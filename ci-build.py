#!/bin/python3

import json
import os

def run(cmd):
	result = os.system(cmd)
	exit_code = os.waitstatus_to_exitcode(result)
	if exit_code != 0:
		exit()

with open("io.github.urlordjames.GreenUpdater.json", "r") as f:
	parsed = json.load(f)
	commit = parsed["modules"][0]["sources"][0]["commit"]

run("git clone 'https://github.com/urlordjames/green-updater.git'")
run(f"cd green-updater && git checkout {commit} && cd ..")
run("flatpak-cargo-vendor green-updater/Cargo.lock -o cargo-source.json")
run("./common-build.sh")
