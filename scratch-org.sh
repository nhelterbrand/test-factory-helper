#!/bin/bash
# @author Nate Helterbrand
# helpful bash script to get started with this repo's code quickly

# create scratch org
echo 'Creating Scratch Org and setting Scratch Org as Default Username (for VSCode SFDX extension use)...'
sfdx force:org:create -f config/project-scratch-def.json -a TestFactoryScratch --setdefaultusername

# push metadata from package to scratch org
echo 'Pushing metadata to the newly created Scratch Org, because otherwise you will forget...'
sfdx force:source:push

# open scratch org
echo 'Opening Scratch Org, so close!...'
sfdx force:org:open -u TestFactoryScratch

echo 'Done! Thanks for checking this out!'