#!/usr/bin/env bash

for directory in "$(pwd)"/*/; do

  cd "$directory/" || exit 5
  if [ -f "Chart.yml" ] || [ -f "Chart.yaml" ]; then
    echo "Linting $directory"

    if ! helm template --debug --set oneagent.apiUrl="test-url" .; then
      echo "could not parse template. something is wrong with template files of directory '$directory'"
      exit 10
    fi

    if ! helm template --debug --set oneagent.apiUrl="test-url" . | yamllint -d "{extends: default, rules: {line-length: disable, trailing-spaces: disable}}" --strict -; then
       echo "linter returned with error. check yaml formatting in files of directory '$directory'." && exit 15
    fi
  else
    echo "$directory does not contain Chart file. skipping..."
  fi
done
