#!/usr/bin/awk

# Usage:
# awk -f key_renamer.awk keyfile file_to_edit

NR==FNR { pattern[NR] = $1; replacement[NR] = $2; count++; next }
{
    for (i = 1; i <= count; i++) {
        sub(pattern[i], replacement[i])
    }
    print $0
}


