#!/bin/bash

# rsync -cauv --delete --info=stats2 --exclude={"caur.files","*.files.tar*","caur.db","*.db.tar*"} /var/cache/pacman/caur/ /home/cretm/app/dev.ctlos.ru/ctlos-aur

# find './' -maxdepth 1 -type f -regex '.*\.\(zst\|xz\)' -exec gpg -b '{}' \;
# find './' -type f -exec gpg --pinentry-mode loopback --passphrase=${GPG_PASS} -b '{}' \;

# apindex .
# ./update.sh -add
# systemctl --user start kbfs
# ./update.sh -all
# surge --project ../ --domain https://ctlos.surge.sh

# https://osdn.net/projects/ctlos/storage/ctlos_repo/x86_64/
# https://github.com/ctlos/ctlos_repo/tree/master/x86_64
# https://cvc.keybase.pub/ctlos_repo/x86_64
# https://ctlos.surge.sh

local_repo=/media/files/github/ctlos/ctlos_repo/
dest_osdn=creio@storage.osdn.net:/storage/groups/c/ct/ctlos/ctlos_repo/
dest_keybase=/run/user/1000/keybase/kbfs/public/cvc/ctlos_repo/

if [ "$1" = "-add" ]; then
  # repo-add -s -v -n -R ctlos_repo.db.tar.gz *.pkg.tar.xz
  # repo-add -n -R ctlos_repo.db.tar.gz *.pkg.tar.{xz,zst}
  repo-add -n -R ctlos_repo.db.tar.gz *.pkg.tar.zst
  rm ctlos_repo.{db,files}
  cp -f ctlos_repo.db.tar.gz ctlos_repo.db
  cp -f ctlos_repo.files.tar.gz ctlos_repo.files
  apindex .
  ##optional-remove for old repo.db##
  # rm *gz.old{,.sig}
echo "Repo Up"
elif [ "$1" = "-clean" ]; then
  rm ctlos_repo*
echo "Repo clean"
elif [ "$1" = "-o" ]; then
  rsync -cauvCLP --delete-excluded --delete "$local_repo"x86_64 "$dest_osdn"
echo "rsync osdn repo"
# systemctl --user start kbfs
elif [ "$1" = "-sync" ]; then
  rsync -cauvCLP --delete-excluded --delete "$local_repo"x86_64 "$dest_osdn"
  rsync -cauvCLP --delete-excluded --delete --exclude={"build",".git*",".*ignore"} "$local_repo"x86_64/ "$dest_keybase"
echo "rsync all repo"
# systemctl --user start kbfs
elif [ "$1" = "-k" ]; then
  rsync -cauvCLP --delete-excluded --delete --exclude={"build",".git*",".*ignore"} "$local_repo"x86_64/ "$dest_keybase"
echo "rsync keybase repo"
else
  echo "No rsync repo"
fi

