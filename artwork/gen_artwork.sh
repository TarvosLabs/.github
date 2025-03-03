#!/bin/bash
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

      # export in all square formats
      if [ "$file_basename" == "banner" ]; then
        size_list=( "500 129" "1000 258" "1500 387" "2000 516" );
      else
        size_list=( "128 128" "256 256" "500 500" "1000 1000" );
      fi

      for size in "${size_list[@]}";
      do
        size=($size);
        echo "${size[0]}, ${size[1]}"
        for mode in "light" "dark";
        do
          if [ "$mode" == "light" ]; then
            inkscape --export-area-page \
            --export-filename=output/"$file_basename"_light_"$size".png \
            --export-width="${size[0]}" --export-height="${size[1]}" \
            "$file"
          else
            sed -e "s/$LIGHT_BACKGROUND/$DARK_BACKGROUND/" \
              -e "s/$LIGHT_PRIMARY/$DARK_PRIMARY/" \
              -e "s/$LIGHT_SECONDARY_1/$DARK_SECONDARY_1/" \
              -e "s/$LIGHT_SECONDARY_2/$DARK_SECONDARY_2/" \
              "$file" | inkscape --pipe \
              --export-area-page \
              --export-filename=output/"$file_basename"_dark_"$size".png \
              --export-width="${size[0]}" --export-height="${size[1]}"
          fi
        done
      done
    fi
done


