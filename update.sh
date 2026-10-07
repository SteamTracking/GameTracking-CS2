#!/bin/bash
set -euo pipefail

cd "${0%/*}"
. ../common.sh

echo "Processing CS2..."

DUMPER_EXIT_CODE=0

ProcessVPK

echo "::group::Extracting VPKs"

set +e
while IFS= read -r -d '' file
do
	echo " $file"

	# When updating vpk_extensions, also update "pak01_dir.vpk:..." in files.json, since only those entries are downloaded
	"$VRF_PATH" \
		--input "$file" \
		--output "$(echo "$file" | sed -e 's/\.vpk$/\//g')" \
		--vpk_cache \
		--vpk_decompile \
		--vpk_extensions "txt,lua,kv3,db,gameevents,vcss_c,vjs_c,vts_c,vxml_c,vsndevts_c,vsndstck_c,vpulse_c,vdata_c"
	VRF_EXIT_CODE=$?
	if [[ "$DUMPER_EXIT_CODE" -eq 0 ]] && [[ "$VRF_EXIT_CODE" -ne 0 ]]; then
		DUMPER_EXIT_CODE=$VRF_EXIT_CODE
	fi
done <   <(find . -type f -name "pak01_dir.vpk" -print0)

while IFS= read -r -d '' file
do
	echo " $file"

	"$VRF_PATH" \
		--input "$file" \
		--output "$(echo "$file" | sed -e 's/\.vpk$/\//g')" \
		--vpk_cache \
		--vpk_decompile \
		--vpk_extensions "vcs"
	VRF_EXIT_CODE=$?
	if [[ "$DUMPER_EXIT_CODE" -eq 0 ]] && [[ "$VRF_EXIT_CODE" -ne 0 ]]; then
		DUMPER_EXIT_CODE=$VRF_EXIT_CODE
	fi
done <   <(find . -type f -name "shaders_vulkan_dir.vpk" -print0)

while IFS= read -r -d '' file
do
	newfile=$(echo "$file" | sed -e 's/_vulkan_[0-9]\+\.vfx$/.slang/g')
	if [[ "$file" != "$newfile" ]]; then
		mv "$file" "$newfile"
	fi
done <   <(find . -type f -name "*_vulkan_*.vfx" -print0)

set -e

echo "::endgroup::"

set +e
../tools/dump_source2.sh CS2
DUMP_SOURCE2_EXIT_CODE=$?
set -e

if [[ "$DUMPER_EXIT_CODE" -eq 0 ]]; then
	DUMPER_EXIT_CODE=$DUMP_SOURCE2_EXIT_CODE
fi

ProcessDepot ".dll" ".exe"
DeduplicateStringsFrom ".dll" ".exe" -- "game/bin/win64/engine2_strings.txt" "game/bin/win64/tier0_strings.txt" "DumpSource2/.stringsignore"

while IFS= read -r -d '' file
do
	sed -i '/\/\/# sourceMappingURL=/d' "$file"
done <   <(find . -type f -name "*.js" -print0)

ProcessToolAssetInfo

FixUCS2

CreateCommit "$(grep "ClientVersion=" game/csgo/steam.inf | grep -o '[0-9\.]*')" "$(grep -o '[0-9\.]*' steam_buildid.txt)"

echo "Done"

exit "$DUMPER_EXIT_CODE"
