#!/bin/sh

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

bcachefs_check_complete() {
    local _rootinfo _dev
    _dev="${1:-/dev/root}"
    [ -e "$_dev" ] || return 0
    _rootinfo=$(udevadm info --query=property "--name=$_dev" 2>/dev/null)
    if strstr "$_rootinfo" "ID_FS_TYPE=bcachefs"; then
        info "Checking, if bcachefs device complete"
        unset __bcachefs_mount
        mount -o ro "$_dev" /tmp >/dev/null 2>&1
        __bcachefs_mount=$?
        [ $__bcachefs_mount -eq 0 ] && umount "$_dev" >/dev/null 2>&1
        return $__bcachefs_mount
    fi
    return 0
}

bcachefs_check_complete "$1"
