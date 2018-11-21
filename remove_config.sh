#!/bin/bash
here=$(cd `dirname $0` && pwd)
backup=$(readlink -f $1)
if [[ "$backup" =~ ^"$here".* ]]; then
  config="$HOME/${backup#"$here"}"
  if [[ -L "$config" ]]; then
    rm "$config" &&
    cp "$backup" "$config" &&
    rm "$backup" &&
    find . -depth -type d -empty -exec rmdir "{}" \; &&
    echo "Succesfully replaced file on system and deleted copy" ||
    (echo "Unable to delete copy or replace file"; exit 4)
  else
    if [[ -f "$backup" ]]; then
      echo "File does not exist on system, or is not a link"
      echo "Possibly safe to simply rm this file"
      exit 2
    else
      echo "File does not exist here"
      exit 3
    fi
  fi
else
  echo "Files must be in this directory: $here, file was: $backup"
  exit 1
fi

