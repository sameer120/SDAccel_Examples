#!/bin/bash -e

HEAD=$1

PROJS=$(git ls-files | grep description.json | sed -e 's/\.\///' -e 's/\/description.json//')
CHANGES=$(git diff --name-only $HEAD)

howmany() { echo $#; }
NUM_CHANGES=$(howmany $CHANGES)

REBUILDS=

# Ignore the following patterns these are checked by the pre-check scripts
for change in $CHANGES; do
	if [[ "$change" == */README.md 
		|| "$change" == "utility/build_what.sh" ]]; then
		NUM_CHANGES=$((NUM_CHANGES-1))
	fi
done

for change in $CHANGES; do
	for proj in $PROJS; do
		if [[ "$change" == ${proj}* ]]; then
			REBUILDS=$proj $REBUILDS
			NUM_CHANGES=$((NUM_CHANGES-1))
		fi
	done
done

# if we know that we only changed something inside a single example then do a rebuild
# of that example only else rebuild all examples.
if [[ "$NUM_CHANGES" == "0" ]]; then
	for rebuild in $REBUILDS; do
		echo $rebuild
	done
else
	for proj in $PROJS; do
		echo $proj
	done
fi