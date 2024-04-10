shopt -s globstar

programs="dev.vencord.Vesktop.desktop|com.visualstudio.code.desktop"

IFS=':'
read -r -a paths <<< "$XDG_DATA_DIRS"

for path in $XDG_DATA_DIRS
do
  if test -d "$path"; then
	# https://stackoverflow.com/a/54561526
	find "$path" -name '*.desktop' -print0 | grep -a -z -E $programs | while read -d $'\0' file
	do
		if ! grep -q -- "--enable-features=UseOzonePlatform --ozone-platform=wayland" $file; then
			cp $file $file.bak
			echo $(sed "/Exec=/ s/$/ --enable-features=UseOzonePlatform --ozone-platform=wayland/" $file) > $file
			echo "patched $(basename $file)"
		fi
	done
  fi
done
