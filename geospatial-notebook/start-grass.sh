#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e

start.sh grass /home/$NB_USER/grassdata

start.sh jupyter notebook $*
