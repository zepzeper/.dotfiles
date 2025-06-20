#!/run/current-system/sw/bin/zsh
# Replace with your actual snippets file path if different
snippets="$HOME/scripts/resources/snippets.json"

# Ensure the file exists
if [ ! -f "$snippets" ]; then
    echo "Snippets file not found: $snippets"
    exit 1
fi

max_category_len=$(jq -r 'to_entries | .[] | .key | length' "$snippets" | sort -nr | head -n 1)
max_name_len=$(jq -r '.[] | .[] | .name | length' "$snippets" | sort -nr | head -n 1)
max_note_len=$(jq -r '.[] | .[] | .note | length' "$snippets" | sort -nr | head -n 1)

# Capture the entire fzf result into a variable. Note: Use a delimiter that's unlikely to appear in your data.
result=$(
    cat "$snippets" | \
    jq -r 'to_entries | .[] | .key as $category | .value[] | "\($category)\t\(.name)\t\(.note)\t\(.content)\t\u0001\(. | @json)"' | \
    awk -F '\t' \
        -v max_category_len="$max_category_len" \
        -v max_name_len="$max_name_len" \
        -v max_note_len="$max_note_len" \
    '{
        printf "\033[35m%-*s\033[0m\t\033[32m%-*s\033[0m\t\033[36m%-*s\033[0m\t\033[33m%s\033[0m\t%s\n", \
        max_category_len, $1, max_name_len, $2, max_note_len, $3, $4, $5
    }' | \
    fzf --ansi --reverse --delimiter='\t' \
         --with-nth=1,2,3 \
         --preview='printf "\033[35m%-15s%s\033[0m\n\033[36m%-15s%s\033[0m\n\033[33m%-15s%s\033[0m\n\033[32m%-15s%s\033[0m\n" "Category ->" "{1}" "Name ->" "{2}" "Note ->" "{3}" "Command ->" "{4}"' \
         --preview-window=up:4:wrap
)

# If you want only the command content (4th field) from the result, you might split the output.
# For example, if your fields are separated by a known delimiter (here tab), you could do:
command_content=$(echo "$result" | awk -F'\t' '{print $4}')

# Now you can copy it to the clipboard, and print a message:
echo "$command_content" | pbcopy
echo "Command copied: \033[33m$command_content"

