#!/usr/bin/env sh
#
# This script pushes my selected files to my GitHub repository
#
# Copyright (c) 2019, Andrey "Limych" Khrolenok <andrey@khrolenok.ru>
# Creative Commons BY-NC-SA 4.0 International Public License
# (see LICENSE.md or https://creativecommons.org/licenses/by-nc-sa/4.0/)
#

WDIR=$(cd `dirname $0` && pwd)
ROOT=$(dirname ${WDIR})

# Check for required utilites and install it if they are not available
git --version >/dev/null || apk -q add git

# Include parse_yaml function
. ${WDIR}/_parse_yaml.sh

# Read yaml file
eval $(parse_yaml ${ROOT}/secrets.yaml)

cd ${ROOT}
git config user.name "${secret_git_user_name}"
git config user.email "${secret_git_user_email}"
if [ "${ROOT}/secrets.yaml" -nt "${ROOT}/tests/fake_secrets.yaml" ]; then
    echo "Updating fake_secrets.yaml"
    ${ROOT}/bin/make_fake_secrets.sh
fi
git add .
git commit -m "$1"
git config core.sshCommand "ssh -i ${ROOT}/.ssh/id_rsa -oStrictHostKeyChecking=no"
git push origin master

exit
