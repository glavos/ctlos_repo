#!/bin/bash

# rsync -cauv --delete --info=stats2 --exclude={"caur.files","*.files.tar*","caur.db","*.db.tar*"} /var/cache/pacman/caur/ /home/cretm/app/dev.glavos.ru/glavos-aur

# find './' -maxdepth 1 -type f -regex '.*\.\(zst\|xz\)' -exec gpg -b '{}' \;
# find './' -type f -exec gpg --pinentry-mode loopback --passphrase=${GPG_PASS} -b '{}' \;

# apindex .
# ./update.sh -add
# systemctl --user start kbfs
# ./update.sh -all
# surge --project ../ --domain https://glavos.surge.sh

# https://osdn.net/projects/glavos/storage/glavos_repo/x86_64/
# https://github.com/glavos/glavos_repo/tree/master/x86_64
# https://cvc.keybase.pub/glavos_repo/x86_64
# https://glavos.surge.sh

local_repo=/media/files/github/glavos/glavos_repo/
dest_osdn=creio@storage.osdn.net:/storage/groups/c/ct/glavos/glavos_repo/
dest_keybase=/run/user/1000/keybase/kbfs/public/cvc/glavos_repo/

if [ "$1" = "-add" ]; then
  # repo-add -s -v -n -R glavos_repo.db.tar.gz *.pkg.tar.xz
  # repo-add -n -R glavos_repo.db.tar.gz *.pkg.tar.{xz,zst}
  repo-add -n -R glavos_repo.db.tar.gz *.pkg.tar.zst
  rm glavos_repo.{db,files}
  cp -f glavos_repo.db.tar.gz glavos_repo.db
  cp -f glavos_repo.files.tar.gz glavos_repo.files
  apindex .
  ##optional-remove for old repo.db##
  # rm *gz.old{,.sig}
echo "Repo Up"
elif [ "$1" = "-clean" ]; then
  rm glavos_repo*
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
elif [ "$1" = "-all" ]; then
  repo-add -n -R glavos_repo.db.tar.gz *.pkg.tar.zst
  rm glavos_repo.{db,files}
  cp -f glavos_repo.db.tar.gz glavos_repo.db
  cp -f glavos_repo.files.tar.gz glavos_repo.files
  apindex .
  rsync -cauvCLP --delete-excluded --delete "$local_repo"x86_64 "$dest_osdn"
  rsync -cauvCLP --delete-excluded --delete --exclude={"build",".git*",".*ignore"} "$local_repo"x86_64/ "$dest_keybase"
  echo "add pkg, rsync all repo"
else
  repo-add -n -R glavos_repo.db.tar.gz *.pkg.tar.zst
  rm glavos_repo.{db,files}
  cp -f glavos_repo.db.tar.gz glavos_repo.db
  cp -f glavos_repo.files.tar.gz glavos_repo.files
  echo "Done repo-add pkg"
fi
