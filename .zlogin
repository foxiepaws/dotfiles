CC=clang
CXX=clang++

EDITOR=vim

PATH="$HOME/.bin:$PATH"
PAGER=most

DISTCC_DIR=/usr/local/etc/distcc
CCACHE_DIR=/data/ccache
CCACHE_NOLINK=yes
CCACHE_UMASK=002
#CCACHE_PREFIX=distcc_wrapper

export CC CXX EDITOR PATH PAGER DISTCC_DIR CCACHE_DIR CCACHE_NOLINK CCACHE_UMASK