#!/bin/bash
here=$(cd `dirname $0` && pwd)
config=$(readlink -f $1)
if [[ "$config" =~ ^"$HOME".* ]]; then
  if [[ -f "$config" ]]; then
    if ! [[ "$config" =~ ^"$here".* ]]; then
      newfile="$here/${config#"$HOME"}"
      mkdir -p "$(dirname $newfile)" &&
      cp "$config" "$newfile" &&
      rm "$config" &&
      ln -s "$newfile" "$config" &&
      echo "Succesfully copied and linked config file" ||
      (echo "Unable to copy and link file!"; exit 4)
    else
      echo "Cannot grab a file already in this directory"
      exit 3
    fi
  else
    echo "File does not exist"
    exit 2
  fi
else
  echo "Files must be in HOME directory: $HOME"
  exit 1
fi

