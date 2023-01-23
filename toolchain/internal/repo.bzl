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

load(
    "//toolchain/internal:common.bzl",
    _os = "os",
    _os_exec_ext = "os_exec_ext",
)
load(
    "//toolchain/internal:llvm_distributions.bzl",
    _download_llvm = "download_llvm",
)

def llvm_repo_impl(rctx):
    os = _os(rctx)

    rctx.template(
        "BUILD.bazel",
        Label("//toolchain:BUILD.llvm_repo.tpl"),
        substitutions = {
            "exec_ext": _os_exec_ext(os),
        },
        executable = False,
    )

    updated_attrs = _download_llvm(rctx)

    # We try to avoid patches to the downloaded repo so that it is easier for
    # users to bring their own LLVM distribution through `http_archive`. If we
    # do want to make changes, then we should do it through a patch file, and
    # document it for users of toolchain_roots attribute.

    return updated_attrs
