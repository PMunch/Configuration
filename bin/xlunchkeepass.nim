#!/usr/bin/env nimcr
import streams, strutils
import xmltree, xmlparser
import libkeepass
import osproc
import base64

template output(s: untyped) =
  discard execProcess("notify-send -u critical -a \"xlunch Keepass\" -i /usr/share/icons/papirus-arc-dark/48x48/apps/keepass2.svg \"" & s & "\"")
  stderr.write(s & "\n")

let
  pw = execProcess("zenity --password", options = {poUsePath, poEvalCommand})
  s = newFileStream("/home/peter/passwords.kdbx", fmRead)
if pw[0..^2] == "":
  output("No password entered!")
  quit 1
try:
  let
    db = readDatabase(s, pw[0..^2])
  echo "DB read"
  var
    passwords: seq[tuple[title, password: string]] = @[]
  for xml in db:
    for group in xml.child("Root"):
      proc parseGroup(group: XmlNode, path: string) =
        let name =
          if group.child("Name") == nil:
            ""
          else:
            if group.child("Name").innerText != "Root":
              #group.child("Name").innerText & "  "
              group.child("Name").innerText & " > "
            else:
              ""
        if group.tag == "Group":
          for entry in group:
            proc parseEntry(entry: XmlNode) =
              if entry.tag == "Entry":
                var title, password: string
                for field in entry:
                  case field.tag:
                  of "String":
                    let
                      keyTag = field.child("Key")
                      valueTag = field.child("Value")
                      key = keyTag.innerText
                      value = valueTag.innerText
                    case key:
                      of "Title":
                        title = path & name & value
                      of "Password":
                        password = value
                passwords.add((title: title,
                  password: password.multiReplace(
                    ("&lt;", "<"),
                    ("&gt;", ">"),
                    ("&amp;", "&"),
                    ("&quot;", "\""),
                    ("&#x27;", "'"),
                    ("&#x2F;", "/"))))
            if entry.tag == "Entry":
              parseEntry(entry)
            elif entry.tag == "Group":
              parseGroup(entry, path & name)
      parseGroup(group, "")
  var entries = ""
  for entry in passwords:
    entries = entries & entry.title & ";/usr/share/xlunch/svgicons/keepassxc.png;" & encode(entry.password) & "\n"
  entries = entries.multiReplace(("\"","\\\""),("$","\\$"))[0..^2]
  let chosen = execProcess("echo \"" & entries & "\" | xlunch-menu --prompt \"Entry: \"")
  #echo chosen
  #echo NimVersion
  #echo decode(chosen).multiReplace(("\"","\\\""),("$","\\$"))[0..^2]
  discard execProcess("xdotool type \"" & decode(chosen.multiReplace(("\"","\\\""),("$","\\$"))[0..^2]) & "\"")
except DecryptionException:
  output("Unable to decrypt database, wrong password?")
  quit 1
