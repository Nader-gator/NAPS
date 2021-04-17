#!/bin/bash
# Nader's arch prep script

### Functions and Constants ###

programsfile="./programs.csv"
aurhelper="yay"
repobranch="master"

installpkg(){
    pacman --noconfirm --needed -S "$1" >/dev/null 2>&1;
}

error() {
    clear; printf "ERROR:\\n%s\\n" "$1" >&2; exit 1;
}

readinpt(){
    local tmpvar
    read -p "$1"$'\n' $2 tmpvar
    echo $tmpvar
}

newperms() {
    # Set special sudoers settings for install (or after).
	sed -i "/#NAPS/d" /etc/sudoers
	echo "$* #NAPS" >> /etc/sudoers
}

### Teh Script ###

# Check if user is root on Arch distro. Install git.
pacman --noconfirm --needed -Sy git || error "Can't install git, are you root?"

# Get and verify username and password.
name=$(readinpt "enter a username")
while ! echo "$name" | grep -q "^[a-z_][a-z0-9_-]*$"; do
name=$(readinpt "Username not valid. username can only begin with a letter, and contain only lowercase letters, - or _.")
done
pass1=$(readinpt "enter a password" -s)
pass2=$(readinpt "re-enter the password" -s)
while ! [ "$pass1" = "$pass2" ]; do
unset pass2
pass1=$(readinpt "passwords don't match, try again" -s)
pass2=$(readinpt "re-enter the password" -s)
done;

# Give warning if user already exists.
! { id -u "$name" >/dev/null 2>&1; } || (
	answer=$(readinpt "user already exists, if you continue, you will wipe the existing users setting that conflict with NAPS. continue?(Y/n)")
	if [[ ! $answer =~ ^[Yy]$ ]]
	then
	    error "User exited."
	fi
)

# Last chance for user to back out before install.
if [[ ! $(readinpt "ready to go. Start?(Y/n)") =~ ^[Yy]$ ]]
then
    error "User exited."
fi

# Refresh Arch keyrings.
(
	echo "Refreshing Arch Keyring..."
	pacman -Q artix-keyring >/dev/null 2>&1 && pacman --noconfirm -S artix-keyring >/dev/null 2>&1
	pacman --noconfirm -S archlinux-keyring >/dev/null 2>&1
) || error "Error automatically refreshing Arch keyring"

for x in curl base-devel ntp zsh; do
	echo "Installing $x as a prerequisite"
	installpkg "$x"
done

echo "Synchronizing system time"
ntpdate 0.us.pool.ntp.org >/dev/null 2>&1

(
    echo "Adding user $name..."
    useradd -m -g wheel -s /bin/zsh "$name" >/dev/null 2>&1 ||
    usermod -a -G wheel "$name" && mkdir -p /home/"$name" && chown "$name":wheel /home/"$name"
    repodir="/home/$name/.local/src"
    mkdir -p "$repodir"; chown -R "$name":wheel "$(dirname "$repodir")"
    echo "$name:$pass1" | chpasswd 
    unset pass1 pass2
) || error "Error adding username and/or password."

[ -f /etc/sudoers.pacnew ] && cp /etc/sudoers.pacnew /etc/sudoers # Just in case

# Allow user to run sudo without password. Since AUR programs must be installed
# in a fakeroot environment, this is required for all builds with AUR.
newperms "%wheel ALL=(ALL) NOPASSWD: ALL"

# Make pacman and yay colorful becuase my computer doesn't need to look like my soul
grep -q "^Color" /etc/pacman.conf || sed -i "s/^#Color$/Color/" /etc/pacman.conf
grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

# Use all cores for compilation.
sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

[ -f "/usr/bin/$aurhelper" ] || (
    (
        echo "Installing \"$aurhelper\", an AUR helper..."
        cd /tmp || exit 1
        rm -rf /tmp/"$aurhelper"*
        curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/"$aurhelper".tar.gz &&
        sudo -u "$name" tar -xvf "$aurhelper".tar.gz >/dev/null 2>&1 &&
        cd "$aurhelper" &&
        sudo -u "$name" makepkg --noconfirm -si >/dev/null 2>&1
        cd /tmp
    ) || error "Failed to install AUR helper."
)
installpkg python-pip
# do the installation
tmpf="$(sed '/^#/d' $programsfile)"
total=$(echo "$tmpf" | wc -l)
aurinstalled=$(pacman -Qqm)
pipinstalled=$(pip freeze)
while IFS=, read -r tag program comment; do
    n=$((n+1))
    echo "$comment" | grep -q "^\".*\"$" && comment="$(echo "$comment" | sed "s/\(^\"\|\"$\)//g")"
    case "$tag" in
        "A") 
            echo "Installing \`$program\` ($n of $total) from the AUR. $program $comment"
            echo "$aurinstalled" | grep -q "^$program$" && return 1
            sudo -u "$name" $aurhelper -S --noconfirm "$program" >/dev/null 2>&1
            ;;
        "P") 
            echo "Installing \`$program\` ($n of $total) from pip. $program $comment"
            echo "$pipinstalled" | grep -q "^$program$" && return 1
            pip install --no-input "$program" >/dev/null 2>&1
            ;;
        *) 
            echo "Installing \`$program\` ($n of $total). $program $comment"
            installpkg "$program"
            ;;
    esac
done <<< "$tmpf"

rm -rf /home/$name/{.config,.local,.profile,.zprofile,.xprofile} 2> /dev/null
ln -sf /home/$name/{.config,.local} "/home/$name/"
cp .zprofile .xprofile "/home/$name/"

# Most important command! Get rid of the beep!
echo "Getting rid of that stupid error beep sound..."
rmmod pcspkr
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

# Make zsh the default shell for the user.
chsh -s /bin/zsh "$name" >/dev/null 2>&1
sudo -u "$name" mkdir -p "/home/$name/.cache/zsh/"

# adding the daemons.
sudo rc-update add sshd && sudo rc-service sshd start
sudo rc-update add fcron && sudo rc-service fcron start
sudo rc-update add tlp && sudo rc-service tlp start
sudo rc-update add lightdm && sudo rc-service lightdm start
sudo rc-update add cupsd && sudo rc-service cupsd start

# make openrc parallel
sed -i "s/^#rc_parallel=\"NO\"/rc_parallel=\"YES\"/" /etc/rc.conf
sed -i "s/resolve [!/mdns_minimal [NOTFOUND=return] resolve [!" /etc/nsswitch.conf

# generate some keys
pass1=$(readinpt "enter a password" -s)
pass2=$(readinpt "re-enter the password" -s)
while ! [ "$pass1" = "$pass2" ]; do
    unset pass2
    pass1=$(readinpt "passwords don't match, try again" -s)
    pass2=$(readinpt "re-enter the password" -s)
done;
unset pass1 pass2

ssh-keygen -t rsa -q -N $pass -f /home/$name/.ssh/id_rsa
ssh-keygen -t ed25519 -q -N $pass -f /home/$name/.ssh/id_ed25519

sudo fcrontab -u $name /home/$name/.config/crontab/crontab
sudo fcrontab /home/$name/.config/crontab/root-crontab

# allow user to change brightness
sudo gpasswd -a $user video

sudo gpasswd -a $user docker


# Tap to click
[ ! -f /etc/X11/xorg.conf.d/40-libinput.conf ] && printf 'Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        # Enable left mouse button by tapping
        Option "Tapping" "on"
        Option "NaturalScrolling" "true"
        Option "PalmDetection" "on"
        Option "TappingDragLock" "on"
        Option "AccelSpeed" "2"
EndSection' > /etc/X11/xorg.conf.d/40-libinput.conf

# make sure thing lock when computer goes to sleep or lid closes
# it's single user for now, maybe with a login manager in the future
# it won't be neccesary
[ ! -f /usr/lib/elogind/system-sleep/lock.sh ] && printf "#!/bin/sh

export XAUTHORITY=\"/home/$name/.Xauthority\"
export DISPLAY=\":0.0\"
case \"\${1}\" in 
    pre)
        su $name -c \"/usr/bin/slock\" &
        sleep 1s;
        ;;
esac" > /usr/lib/elogind/system-sleep/lock.sh
sudo chmod +x /usr/lib/elogind/system-sleep/lock.sh


if [[ $(readinpt "set up borg backups?(Y/n)") =~ ^[Yy]$ ]]
then
    passphrase=$(openssl rand -hex 18)
    repo=$(readinpt "enter a remote repo name, leave empty if there's none")
    localrepo=$(readinpt "enter a local repo name, leave empty if there's none")
    config=.config/borg-config.yaml
    cron=.config/crontab/cron.h-hour/borgmatic.sh

    sed "s/{{ BORG_PASSPHRASE }}/$passphrase/" templates/borg.yaml > $config

    if [[ -z $localrepo ]] && [[ -z $repo ]];
    then
        echo "you must provide atleast one repo type"
        exit 1
    fi

    if [[ -z $localrepo ]];
    then
        sed -i "/{{ BORG_LOCAL_REPO }}/d" $config
    else
        sed -i "s/{{ BORG_LOCAL_REPO }}/$localrepo/" $config
    fi
    if [[ -z $repo ]];
    then
        sed -i "/{{ BORG_REMOTE_REPO }}/d" $config
    else
        sed -i "s/{{ BORG_REMOTE_REPO }}/$repo/" $config
    fi

    printf "borgmatic --syslog-verbosity 1 -c /$name/$config
    " > $cron
    chmod +x $cron
fi

# This line, overwriting the `newperms` command above will allow the user to run
# serveral important commands, `shutdown`, `reboot`, updating, etc. without a password.
newperms "%wheel ALL=(ALL) ALL #NAPS
%wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/packer -Syu,/usr/bin/packer -Syyu,/usr/bin/rc-service NetworkManager restart,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/yay,/usr/bin/pacman -Syyuw --noconfirm"

echo "it's done"
