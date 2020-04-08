# Node.js and Java environment with the Jekyll static web site builder

The base is a stable version of the official Node.js, with the Jekyll static
web site builder added into this from a full Ruby development environment
(through a multi-stage build defined in the Dockerfile), but leaving the Ruby
development tools behind. The official AWS command-line tools defined as a
Python package are also in the image, but the installation for these uses
binary (Wheel) packages, so does not require a full Python development
environment. The jq package that is also included is a JSON parser, which helps
with OAuth authentication when Bitbucket Pipelines use this image. A stable
version of OpenJDK provides a limited Java runtime environment: this isn't
built, but extracted directly from one of the official OpenJDK Docker images.

Note that the Gemfile and Gemfile.lock files determine the Jekyll build, and
are also in the final built image.

The particular combination of tools in this image is useful for Bootstrap
builds.