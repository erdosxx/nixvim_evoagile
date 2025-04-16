# just is a command runner, Justfile is very similar to Makefile, but simpler.

# use nushell for shell commands
set shell := ["zsh", "-c"]

############################################################################
#
#  Common commands(suitable for all machines)
#
############################################################################
run:
  nix run .

# update all the flake inputs
up:
  nix flake update

# rollback to a specific commit hash
back hash: 
  git checkout {{hash}} -- flake.lock flake.lock

# Update specific input
# Usage: just upp nixpkgs
upp input:
  nix flake update {{input}}

fmt:
  nix fmt
