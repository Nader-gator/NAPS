#!/bin/bash
if [ $(which pip3) = "/usr/bin/pip3" ]; then
    echo "Virtual environment not active"
    exit 1
fi
pip3 install wheel
pip3 install black pyright ipdb ipython neovim
