export ANDROID_HOME=/usr/local/opt/android-sdk
export FINDBUGS_HOME=/usr/local/Cellar/findbugs/3.0.1/libexec
export GRADLE_HOME=/usr/local/bin
export GRADLE_OPTS="-Xmx2048M"
export HOMEBREW_EDITOR="nano"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_121.jdk/Contents/Home
export JAVA_OPTS="-Xmx1024M -XX:ReservedCodeCacheSize=512M"
export PS1="\[$(tput setaf 2)\]\u \[$(tput setaf 4)\] \w>\[$(tput sgr0)\] "

# If in iTerm, sets the tab name to the current directory base name
if [ $ITERM_SESSION_ID ]; then
    export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ':"$PROMPT_COMMAND";
fi

#######
# GIT #
#######

# Shortcut for git stash pop
pop() {
    git stash pop
}

# Shortcut for git stash
stash() {
    git stash
}

#######
# APK #
#######

# Shortcut for doing a 3-way Amazon App Store sign
amazonify() {
    apk-sign $1
    apk-align $1 $2
}

apk-align() {
    zipalign -v 4 $1 $2
}

apk-sign() {
    jarsigner -verbose -sigalg MD5withRSA -digestalg SHA1 -keystore {{keystore_path}} -storepass {{store_pass}} $1 {{store_alias}}
}

########
# MISC #
########

# Restarts ADB
adb-restart() {
    adb kill-server
    adb start-server
}

# Backups existing homebrew config to a runnable script
# see https://gist.githubusercontent.com/lillicoder/032ea23a1c1e12f87686/raw/2376b4d620c91c532b2f8e57ab7b8259377f2e86/brew_backup.sh
brew-backup() {
	local file="brew_restore.sh"

	if [ -f "$file" ]
	then
		read -p "Backup file $file already exists, remove previous backup (y/n)? " -n 1 -r removeReply
		echo

		if [ "$removeReply" = "Y" -o "$removeReply" = "y" ]
		then
			rm -f $file
		else
			exit
		fi
	fi

	touch "$file"
	echo "Starting backup..."

	echo '#!/bin/bash' >> $file
	echo '' >> $file
	echo 'failed_items=""' >> $file
	echo 'function install_package() {' >> $file
	echo 'echo EXECUTING: brew install $1 $2' >> $file
	echo 'brew install $1 $2' >> $file
	echo '[ $? -ne 0 ] && $failed_items="$failed_items $1" # package failed to install.' >> $file
	echo '}' >> $file

	echo
	echo "Processing taps..."
	brew tap | while read tap;
	do
		echo "brew tap $tap" >> $file
		echo "Backed up $tap"
	done

	echo
	echo "Processing packages..."
	brew list | while read item;
	do
		echo "install_package $item '$(brew info $item | /usr/bin/grep 'Built from source with:' | /usr/bin/sed 's/^[ \t]*Built from source with:/ /g; s/\,/ /g')'" >> $file
		echo "Backed up $item"
	done

	echo '[ ! -z $failed_items ] && echo The following items failed to install: && echo $failed_items' >> $file

	echo
	echo "Homebrew configuration backed up to $file"

	if [ ! -z "$failed_items"]
	then
		echo "The following items failed to install: $failed_items"
	fi
}

# Alias for ls -la
ll() {
    if [ -n $1 ]
    then
        ls -la $1
    else
        ls -la
    fi
}
