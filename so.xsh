#!/usr/bin/env xonsh

$XONSH_SHOW_TRACEBACK = True

from os.path import dirname,abspath
import platform

trace on

DIR = dirname(abspath(__file__))
DIST=f"{DIR}/dist/{platform.system().lower()}/{platform.machine()}"

mkdir -p @(DIST)

cd @(DIR)/blake3/c

OUT=f"{DIST}/blake3.so"

gcc -shared -O3 -o @(OUT) blake3.c blake3_dispatch.c blake3_portable.c \
    blake3_sse2_x86-64_unix.S blake3_sse41_x86-64_unix.S blake3_avx2_x86-64_unix.S \
    blake3_avx512_x86-64_unix.S

print(OUT)
