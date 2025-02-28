# Generate artwork png files

# color palette for light mode
LIGHT_BACKGROUND="fill:#ffffff"
LIGHT_PRIMARY="fill:#1b2c36"
LIGHT_SECONDARY_1="fill:#4b7792"
LIGHT_SECONDARY_2="fill:#6694ac"

# color palette for dark mode (HSL with L = 100-L)
DARK_BACKGROUND="fill:#000000"
DARK_PRIMARY="fill:#c9dae4"
DARK_SECONDARY_1="fill:#6e9ab4"
DARK_SECONDARY_2="fill:#528098"


rm output/*

# for all files
for file in editable/*.svg; do
    if [ -f "$file" ]; then
      file_name="${file##*/}"
      file_basename="${file_name%.svg}"
      echo "$file_basename"

      # export in all formats
      for size in "128" "256" "500" "1000";
      do
        for mode in "light" "dark";
        do
          if [ "$mode" == "light" ]; then
            inkscape --export-area-page \
            --export-filename=output/"$file_basename"_light_"$size".png \
            --export-height="$size" --export-width="$size" \
            "$file"
          else
            sed -e "s/$LIGHT_BACKGROUND/$DARK_BACKGROUND/" \
              -e "s/$LIGHT_PRIMARY/$DARK_PRIMARY/" \
              -e "s/$LIGHT_SECONDARY_1/$DARK_SECONDARY_1/" \
              -e "s/$LIGHT_SECONDARY_2/$DARK_SECONDARY_2/" \
              "$file" | inkscape --pipe \
              --export-area-page \
              --export-filename=output/"$file_basename"_dark_"$size".png \
              --export-height="$size" --export-width="$size"
          fi
        done
      done
  fi
done


