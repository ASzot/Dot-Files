# Usage: sh to_grammarly.sh source_tex_folder/ keyword_to_ignore
# Example usage: sh to_grammarly.sh p-mbirlo/sections tables
echo "Converting:"
find $1 -name "*tex" -type f ! -path "*$2*" -exec ls -l {} \;
find $1 -name "*tex" -type f ! -path "*$2*" -exec pandoc  --wrap=preserve -s {} -t markdown \; > grammarly_upload.txt
cat grammarly_upload.txt | pbcopy
