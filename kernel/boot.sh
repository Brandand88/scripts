#!/usr/bin/env bash

ROOT=$(dirname "$(readlink -f "${0}")")

# Parse parameters
function parse_parameters() {
    BOOT_QEMU_ARGS=()
    while ((${#})); do
        case ${1} in
            -k | --kbuild-folder)
                KERNEL=true
                BOOT_QEMU_ARGS+=("${1}")
                ;;
            *)
                BOOT_QEMU_ARGS+=("${1}")
                ;;
        esac
        shift
    done

    ${KERNEL:=false} || BOOT_QEMU_ARGS+=(-k .)
}

# Update/download boot-utils
function dwnld_upd_boot_utils() {
    BOOT_UTILS=${ROOT}/boot-utils
    [[ -d ${BOOT_UTILS} ]] || git clone https://github.com/ClangBuiltLinux/boot-utils "${BOOT_UTILS}"
    git -C "${BOOT_UTILS}" pull || exit ${?}
}

# Run boot-qemu.sh
function invoke_boot_qemu() {
    "${BOOT_UTILS}"/boot-qemu.sh "${BOOT_QEMU_ARGS[@]}"
}

parse_parameters "${@}"
dwnld_upd_boot_utils
invoke_boot_qemu
