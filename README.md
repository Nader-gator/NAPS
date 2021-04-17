# Nader's Arch Prep Script(NAPS)

## What this is

I nuke my laptop (sometimes accidentally) and have many different computers and VMs. I wanted to have a script that
I can run in a fresh install of Artix linux and create an identical system to what I'm used to, eliminating any
"What did I do last time to make this happen again?" moments. It essentially installs all the programs I use
and symlinks the config files to the right place. This means any config chages are tracked by git. 

## Installation:

You can install this by cloning the repo into the `$HOME` of any user(can be root) and, running `naps.sh` and 
following the prompts(you'll create a user there), It's mostly automated. If you want to use Borg to backup 
everything(you should), run the `borgmatic.sh` script. You can set up a local backup and a remote backup
if you have one (you should). You will need to provide the directory and remote address for those backups.

*Warning*, this script will nuke your user settings if you create a user with a name that already exists. This script
was made by me for me, so it can introduce unexpected behavior/software to your system. Don't use this unless you know
what you are doing.
