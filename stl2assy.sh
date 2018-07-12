#!/bin/bash

com="cat"
comr="rm -rf"

for filename in *.stl; do
   if [ $filename = "ASSY.stl" ]; then
      rm -rf $filename
   else
      name="${filename%.*}"
      new="$name""_new.stl"
      com="$com $new"
      comr="$comr $new"

      echo Modifying STL body for $name...

      # substitute the first line and exit
      head -n 1 $filename | sed 's/.*/solid $name/' > $new
      # add the rest of the file (probably quicker than sed)
      tail -n +2 $filename >> $new
      # cut off the last line of the file
      truncate -s $(( $(stat -c "%s" $new) - $(tail -n 1 $new | wc -c) )) $new
      # substitute the last line
      tail -n 1 $filename | sed 's/.*/endsolid $name/' >> $new

      rm -rf $filename
   fi
done

com="$com > ASSY.stl"
com
echo $comr
