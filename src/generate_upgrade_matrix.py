#!/usr/bin/env python

import requests
import json

# Read in releases from GitHub API

# For testing, lest's use a JSON file instead
with open('src/releases.json', 'r') as releases_file:
    releases_list = json.load(releases_file)

# Trim list to only releases from 6.0.4 onwards
post_604_releases = [release for release in releases_list if \
    (int(release['name'][1])==6 and int(release['name'][5])==4) or \
    int(release['name'][1]) > 6]

# Set upgrade versions to target for each release
matrix = {release['name']: [] for release in post_604_releases}

job_count = 0
for start_version, _ in matrix.items():
    matrix[start_version] = [
    release['name'] \
    for release in post_604_releases \
    if int(release['name'][1]) > int(start_version[1])]
    job_count += 1 + len(matrix[start_version])

# print(f'Upgrade matrix ({job_count} jobs):\n{matrix}')
# Assemble includes:
includes = []
for version, upgrades in matrix.items():
    for upgrade in upgrades:
        includes.append({'gaia_version':version, 'upgrade_version':upgrade})
print(includes)