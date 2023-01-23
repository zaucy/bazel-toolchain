# Copyright 2021 The Bazel Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package(default_visibility = ["//visibility:public"])

# Some targets may need to directly depend on these files.
exports_files(glob([
    "bin/*",
    "lib/*",
    "include/*",
]))

## LLVM toolchain files

filegroup(
    name = "clang",
    srcs = [
        "bin/clang{exec_ext}",
        "bin/clang++{exec_ext}",
        "bin/clang-cpp{exec_ext}",
    ],
)

filegroup(
    name = "ld",
    srcs = [
        "bin/ld.lld",
    ],
)

filegroup(
    name = "include",
    srcs = glob([
        "include/**/c++/**",
        "lib/clang/*/include/**",
    ]),
)

filegroup(
    name = "bin",
    srcs = glob(["bin/**"]),
)

filegroup(
    name = "lib",
    srcs = glob(
        [
            "lib/**/lib*.a",
            "lib/clang/*/lib/**/*.a",
            # clang_rt.*.o supply crtbegin and crtend sections.
            "lib/**/clang_rt.*.o",
        ],
        exclude = [
            "lib/libLLVM*.a",
            "lib/libclang*.a",
            "lib/liblld*.a",
        ],
    ),
    # Do not include the .dylib files in the linker sandbox because they will
    # not be available at runtime. Any library linked from the toolchain should
    # be linked statically.
)

filegroup(
    name = "ar",
    srcs = ["bin/llvm-ar{exec_ext}"],
)

filegroup(
    name = "as",
    srcs = [
        "bin/clang{exec_ext}",
        "bin/llvm-as{exec_ext}",
    ],
)

filegroup(
    name = "nm",
    srcs = ["bin/llvm-nm{exec_ext}"],
)

filegroup(
    name = "objcopy",
    srcs = ["bin/llvm-objcopy{exec_ext}"],
)

filegroup(
    name = "objdump",
    srcs = ["bin/llvm-objdump{exec_ext}"],
)

filegroup(
    name = "profdata",
    srcs = ["bin/llvm-profdata{exec_ext}"],
)

filegroup(
    name = "dwp",
    srcs = ["bin/llvm-dwp{exec_ext}"],
)

filegroup(
    name = "ranlib",
    srcs = ["bin/llvm-ranlib{exec_ext}"],
)

filegroup(
    name = "readelf",
    srcs = ["bin/llvm-readelf{exec_ext}"],
)

filegroup(
    name = "strip",
    srcs = ["bin/llvm-strip{exec_ext}"],
)

filegroup(
    name = "symbolizer",
    srcs = ["bin/llvm-symbolizer{exec_ext}"],
)

filegroup(
    name = "clang-tidy",
    srcs = ["bin/clang-tidy{exec_ext}"],
)