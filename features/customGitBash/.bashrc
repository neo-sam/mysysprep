export LESS='-iMSR -j 4'

if ! [ -x "$(command -v man)" ]; then
	man() {
		$1 --help 2>&1 | less
	}
fi
