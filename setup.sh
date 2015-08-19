#!/usr/bin/env bash

# a quick and dirty script for setting up symlinks


files="$(ls -a  | perl -ne 'print unless /^\.{1,2}$|\.org|#$|^\.git$|setup\.../')"

for p in $files; do
    if [[ "${p#/}" == ".config" ]]; then
        mkdir -p "${HOME}/.config"
        mfiles="$(ls -a .config | perl -ne 'print unless /^\.{1,2}$/')"
        for f in $mfiles ; do 
            ln -s "${PWD}/${p}/${f}" "$HOME/.config/${f%.config/}"
        done
    elif [[ "${p#/}" == ".bin" ]]; then
        mkdir -p "${HOME}/.bin"
        mfiles="$(ls -a .bin | perl -ne 'print unless /^\.{1,2}$/')"
        for f in $mfiles ; do 
            ln -s "${PWD}/${f}" "$HOME/.bin/${f%.bin/}"
        done
    else 
        ln -s "${PWD}/${p}" "$HOME/${p}"
    fi
done
    
