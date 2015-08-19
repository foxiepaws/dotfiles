#!/usr/bin/env bash

# a quick and dirty script for setting up symlinks


files="$(ls -a  | perl -ne 'print unless /^\.{1,2}$|\.org|#$|^\.git$|setup\.../')"

for p in $files; do
    if [[ "${p#/}" == ".config" ]]; then
        mkdir -p "${HOME}/.config"
        mfiles="$(ls -a .config | perl -ne 'print unless /^\.{1,2}$/')"
        for f in $mfiles ; do 
            echo "ln -s '${p}/${f}' \"$HOME/.config/${f%.config/}\""
        done
    elif [[ "${p#/}" == ".bin" ]]; then
        mkdir -p "${HOME}/.bin"
        mfiles="$(ls -a .bin | perl -ne 'print unless /^\.{1,2}$/')"
        for f in $mfiles ; do 
            echo "ln -s '${f}' \"$HOME/.bin/${f%.bin/}\""
        done
    else 
        echo "ln -s '${p}' \"$HOME/${p}\""
    fi
done
    
