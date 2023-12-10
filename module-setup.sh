#!/bin/bash

# called by dracut
check() {
    # if we don't have bcachefs installed on the host system,
    # no point in trying to support it in the initramfs.
    require_binaries bcachefs || return 1

    [[ $hostonly ]] || [[ $mount_needs ]] && {
        for fs in "${host_fs_types[@]}"; do
            [[ $fs == "bcachefs" ]] && return 0
        done
        return 255
    }

    return 0
}

# called by dracut
depends() {
    echo udev-rules
    return 0
}

# called by dracut
installkernel() {
    instmods bcachefs
}

# called by dracut
install() {
    inst_rules "$moddir/80-bcachefs.rules"
    case "$(bcachefs --help)" in
    *)
        inst_script "$moddir/bcachefs_finished.sh" /sbin/bcachefs_finished
        ;;
    esac

    inst "$(command -v bcachefs)" /sbin/bcachefs
    ln -sf bcachefs /sbin/mount.bcachefs
    # Hack for slow machines
    # see https://github.com/dracutdevs/dracut/issues/658
    echo "rd.driver.pre=bcachefs" >"${initdir}"/etc/cmdline.d/00-bcachefs.conf
}
