#!/usr/bin/env fish

if test (count $argv) -eq 0
    echo "Usage: ./run.fish <init|plan|apply|...>"
    exit 1
end

set -l env_file (status dirname)/../.env

if not test -f $env_file
    echo "Error: .env not found at $env_file"
    exit 1
end

set -l env_args

while read -l line
    if string match -qr '^#|^\s*$' -- $line
        continue
    end
    set -l key (string split -m1 '=' -- $line)[1]
    set -l val (string split -m1 '=' -- $line)[2]

    switch $key
        case DO_TOKEN
            set -a env_args TF_VAR_do_token=$val
        case AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
            set -a env_args $key=$val
    end
end < $env_file

env $env_args terraform $argv
