#!/usr/bin/env sh

sudo nixos-rebuild test --flake ".#default" --impure
