virtualz-tmp () {
    local venv_name=$(python -c 'import uuid,sys; sys.stdout.write(str(uuid.uuid4())+"\n")' 2>/dev/null)
    if [ -z "$venv_name" ]
    then
        # This python does not support uuid
        venv_name=$(python -c 'import random,sys; sys.stdout.write(hex(random.getrandbits(64))[2:-1]+"\n")' 2>/dev/null)
    fi
    if [ -z "$venv_name" ]; then
        echo "Cannot generate temporary venv!"
        exit 1
    fi
    local venv_path="${VIRTUALZ_HOME}/${venv_name}"

    virtualz-venv "$@" "${venv_path}"
    local venv_status=$?

    if [[ ${venv_status} -eq 0 && -d ${venv_path} ]] ; then
        echo "This is a temporary environment. It will be deleted when you run 'deactivate'." | tee "${venv_path}/README.tmpenv"
        cat - >> "${venv_path}/bin/postdeactivate" <<EOF
if [ -f "${venv_path}/README.tmpenv" ]
then
    echo "Removing temporary environment: ${venv_path}"
    virtualz-rm "${venv_name}"
fi
EOF
        virtualz-activate "${venv_name}"
    else
        echo "virtualenv returned status ${venv_status}" 1>&2
        return ${venv_status}
    fi
}

virtualz-deactivate () {
    if [[ ${VIRTUAL_ENV:+set} != set ]] ; then
        echo 'No virtualenv is active.' 1>&2
        return 1
    fi

    # Remove element from $PATH
    local venv_bin="${VIRTUAL_ENV}/bin"
    local -a new_path=( )
    for path_item in "${path[@]}" ; do
        if [[ ${path_item} != ${venv_bin} ]] ; then
            new_path=( "${new_path[@]}" "${path_item}" )
        fi
    done
    path=( "${new_path[@]}" )

    # Restore PYTHONHOME
    if [[ ${_VIRTUALZ_OLD_PYTHONHOME:+set} = set ]] ; then
        export PYTHONHOME=${_VIRTUALZ_OLD_PYTHONHOME}
        unset _VIRTUALZ_OLD_PYTHONHOME
    fi

    if [ -f ${VIRTUAL_ENV}/bin/postdeactivate ]; then
        local postdeactivate="${VIRTUAL_ENV}/bin/postdeactivate"
    fi

    unset VIRTUAL_ENV VIRTUAL_ENV_NAME

    if [ ! -z "$postdeactivate" ]; then
        source $postdeactivate
    fi
}