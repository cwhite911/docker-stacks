#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e

source ~/venv2/bin/activate

grass73 /home/$NB_USER/grassdata/nc_spm_08_grass7/user1/ --exec jupyter notebook $*

source deactivate
