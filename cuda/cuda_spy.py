#!/usr/bin/env python3

import ctypes
import sys

libfile = '/usr/local/cuda/lib64/libcudart.so'
funcname = 'cudaRuntimeGetVersion'

if 2 <= len(sys.argv):
    libfile = sys.argv[1]
if 3 <= len(sys.argv):
    libfile = sys.argv[2]

runtime_so = ctypes.CDLL(libfile)
func = getattr(runtime_so, funcname, None)
func.restype = ctypes.c_int  # cudaError_t
func.argtypes = [ctypes.POINTER(ctypes.c_int)]
version_ptr = ctypes.c_int()
retval = func(version_ptr)
assert retval == 0, retval
print(version_ptr.value)
