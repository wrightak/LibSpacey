#!/usr/bin/env bash

function go_to_project_top_directory() {
  local -r script_dir=$(dirname "${BASH_SOURCE[0]}")

  cd "$script_dir/../.." || exit 1
}

function install_conan_dependencies() {
  pushd common || exit 1
  conan install . -s build_type=Debug --install-folder=cmake-build-debug
  conan install . -s build_type=Release --install-folder=cmake-build-release
  popd || exit 1
}

function build_library() {
  pushd common/cmake-build-debug || exit 1
  cmake ../
  make
  popd || exit 1
}

function run_tests() {
  pushd common/cmake-build-debug/bin || exit 1
  ./run_test
  popd || exit 1
}

function main() {
  go_to_project_top_directory
  source ./scripts/shared/shared.sh || exit 1
  shared.set_bash_error_handling

  install_conan_dependencies
  build_library
  run_tests

  shared.display_success_message "Library tests completed successfully 🧪"
}

main
