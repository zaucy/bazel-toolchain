# Copyright 2018 The Bazel Authors.
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

exports_files(["Makevars"])

filegroup(
    name = "empty",
    srcs = [],
)

filegroup(
    name = "cc_wrapper",
    srcs = ["bin/cc_wrapper.sh"],
)

filegroup(
    name = "sysroot_components",
    srcs = [%{sysroot_label}],
)

cc_toolchain_suite(
    name = "toolchain",
    toolchains = {
        "k8|clang": ":cc-clang-linux",
        "darwin|clang": ":cc-clang-darwin",
        "k8": ":cc-clang-linux",
        "darwin": ":cc-clang-darwin",
        "x64_windows": ":cc-clang-win64",
    },
)

load(":cc_toolchain_config.bzl", "cc_toolchain_config")

cc_toolchain_config(
    name = "local_linux",
    cpu = "k8",
)

cc_toolchain_config(
    name = "local_darwin",
    cpu = "darwin",
)

cc_toolchain_config(
    name = "local_win64",
    cpu = "x64_windows",
)

toolchain(
    name = "cc-toolchain-darwin",
    exec_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:osx",
    ],
    target_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:osx",
    ],
    toolchain = ":cc-clang-darwin",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
    name = "cc-toolchain-linux",
    exec_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
    ],
    target_compatible_with = [
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
    ],
    toolchain = ":cc-clang-linux",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

toolchain(
    name = "cc-toolchain-win64",
    exec_compatible_with = [
        "@platforms//cpu:x64_windows",
        "@platforms//os:windows",
    ],
    target_compatible_with = [
        "@platforms//cpu:x64_windows",
        "@platforms//os:windows",
    ],
    toolchain = ":cc-clang-win64",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

load("@com_grail_bazel_toolchain//toolchain:rules.bzl", "conditional_cc_toolchain")

conditional_cc_toolchain("cc-clang-linux",
    toolchain_config = "local_linux",
    toolchain_identifier = "clang-linux",
    absolute_paths = %{absolute_paths},
    supports_param_files = 1,
)

conditional_cc_toolchain("cc-clang-darwin",
    toolchain_config = "local_darwin",
    toolchain_identifier = "clang-darwin",
    absolute_paths = %{absolute_paths},
    supports_param_files = 0,
    extra_files = [":cc_wrapper"],
)

conditional_cc_toolchain("cc-clang-win64",
    toolchain_config = "local_win64",
    toolchain_identifier = "clang-win64",
    absolute_paths = %{absolute_paths},
    supports_param_files = 0,
)

## LLVM toolchain files
# Needed when not using absolute paths.

filegroup(
    name = "clang",
    srcs = [
        "bin/clang%{exe}",
        "bin/clang++%{exe}",
        "bin/clang-cpp%{exe}",
    ],
)

filegroup(
    name = "ld",
    srcs = [
        "bin/ld.lld",
        "bin/ld",
        "bin/ld.gold",  # Dummy file on non-linux.
    ],
)

filegroup(
    name = "include",
    srcs = glob([
        "include/c++/**",
        "lib/clang/%{llvm_version}/include/**",
    ]),
)

filegroup(
    name = "lib",
    srcs = glob(
        [
            "lib/lib*.a",
            "lib/clang/%{llvm_version}/lib/**/*.a",
        ],
        exclude = [
            "lib/libLLVM*.a",
            "lib/libclang*.a",
            "lib/liblld*.a",
        ],
    ),
)

filegroup(
    name = "compiler_components",
    srcs = [
        ":clang",
        ":include",
        ":sysroot_components",
    ],
)

filegroup(
    name = "ar",
    srcs = ["bin/llvm-ar%{exe}"],
)

filegroup(
    name = "as",
    srcs = ["bin/llvm-as%{exe}"],
)

filegroup(
    name = "nm",
    srcs = ["bin/llvm-nm%{exe}"],
)

filegroup(
    name = "objcopy",
    srcs = ["bin/llvm-objcopy%{exe}"],
)

filegroup(
    name = "objdump",
    srcs = ["bin/llvm-objdump%{exe}"],
)

filegroup(
    name = "profdata",
    srcs = ["bin/llvm-profdata%{exe}"],
)

filegroup(
    name = "dwp",
    srcs = ["bin/llvm-dwp%{exe}"],
)

filegroup(
    name = "ranlib",
    srcs = ["bin/llvm-ranlib%{exe}"],
)

filegroup(
    name = "readelf",
    srcs = ["bin/llvm-readelf%{exe}"],
)

filegroup(
    name = "binutils_components",
    srcs = glob(["bin/*"]),
)

filegroup(
    name = "linker_components",
    srcs = [
        ":clang",
        ":ld",
        ":ar",
        ":lib",
        ":sysroot_components",
    ],
)

filegroup(
    name = "all_components",
    srcs = [
        ":binutils_components",
        ":compiler_components",
        ":linker_components",
    ],
)
