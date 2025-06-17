#!/bin/bash

echo "$(date +"%d-%m-%Y %T"): Started automatic release" >> release.log

if git diff --quiet $(git describe --tags --abbrev=0); then
    echo "$(date +"%d-%m-%Y %T"): Nothing new to release" >> release.log
else
    echo "$(date +"%d-%m-%Y %T"): Changes detected, starting new release" >> release.log
    # Compile the document
    arara tesi.tex >> release.log
    # Create the new release
    echo "$(date +"%d-%m-%Y %T"): A new release tagged $(date +"v%m.%d") will be created" >> release.log
    gh release create $(date +"v%m.%d") tesi.pdf -t "$(date +"%B %d, %Y")" --generate-notes --latest
    echo "$(date +"%d-%m-%Y %T"): Release created, going to sleep" >> release.log
fi
