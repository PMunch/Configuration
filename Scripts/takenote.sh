if [ ! -d ~/.notes ]; then
	mkdir ~/.notes
fi
echo "WELCOME"
if [ $1 == "clip" ]; then
  NOTE=$(xclip -selection p -o)
elif [ $1 == "img" ]; then
  echo "IMAGE"
  EMBEDDED=~/.notes/$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 5).png
  while [ -f $EMBEDDED ]; do
    EMBEDDED=~/.notes/$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 5).png
  done
  sleep 0.2; scrot -s $EMBEDDED
	EMBEDDED="\"$EMBEDDED\""
fi
WINDOWPID=$(xdotool getwindowfocus getwindowpid)
PROGRAMNAME=$(ps -p $WINDOWPID -o comm=)
if [ $PROGRAMNAME == epdfview ]; then
  SOURCE=$(lsof -Fn -p $WINDOWPID | grep "\.pdf" | cut -c2-)
elif [ $PROGRAMNAME == qpdfview ]; then
	TITLE=$(xdotool getwindowfocus getwindowname | head -c-11)
	while read -r line; do
		echo "$line"
		LINETITLE=$(pdfinfo "$line" | grep Title | awk '{for(i=2;i<=NF;++i) print $i}' ORS=' ')
		if [ "$LINETITLE" == "" ]; then
			if [ "$TITLE" == "$(basename "$line" | head -c-5) " ]; then
				SOURCE="$line"
			fi
		elif [ "$TITLE" == "$LINETITLE" ]; then
			SOURCE="$line"
		fi
	done <<< $(lsof -Fn -p $WINDOWPID | grep "\.pdf" | cut -c2- | head -c-1)
	if [ "$SOURCE" == "" ]; then
		SOURCE=$(xdotool getwindowfocus getwindowname)
	fi
elif [ $PROGRAMNAME == vivaldi-bin ]; then
	OLDCLIP=$(xclip -selection c -o)
  sleep 0.2; xdotool key --clearmodifiers ctrl+l key --clearmodifiers ctrl+c key --clearmodifiers Escape
	SOURCE=$(xclip -selection c -o)
  echo "$OLDCLIP" | xclip -selection c -i
else
	SOURCE=$(xdotool getwindowfocus getwindowname)
fi

if [ -z $2 ]; then
	TARGET="&1"
else
	TARGET=~/.notes/$2.nb
  if [ ! -f $TARGET ]; then
		echo -e "{\"notebook\":\"$2\", \"notes\":[\n\n]}" > $TARGET
		NEW=yes
	fi
	dd if=/dev/null of=$TARGET bs=1 seek=$(echo $(stat --format=%s $TARGET ) - 4 | bc )
	if [ -z ${NEW+x} ]; then
		echo "," >> $TARGET
	fi
fi
echo "{\"time\":\"$(date)\",\"source\":$(jshon -s "$SOURCE"),\"note\":$(jshon -s "$NOTE"),\"embedded\":[$EMBEDDED]}" >> $TARGET
if [ ! -z $2 ]; then
	echo "]}" >> $TARGET
fi
