#!/bin/bash

shopt -s nullglob nocaseglob

MAX_JOBS=$(nproc)
CURRENT_JOBS=0

for file in *.mp4; do
    (
        filename="${file%.*}"
        output="${filename}c.mp4"

        if [[ ! -f "$output" ]]; then
            echo "🎬 Convirtiendo $file"

            ffmpeg -loglevel error \
                -i "$file" \
                -c:v libx264 -crf 27 -preset slow \
                -c:a aac -b:a 128k \
                "$output" > /dev/null 2>&1

            if [[ $? -eq 0 ]]; then
                echo "✅ Terminado $output"
            else
                echo "❌ Error en $file"
            fi
        fi
    ) &

    ((CURRENT_JOBS++))

    if [[ $CURRENT_JOBS -ge $MAX_JOBS ]]; then
        wait -n
        ((CURRENT_JOBS--))
    fi
done

wait
echo "🚀 Todo terminado"
