#!/bin/bash

python3 -m venv ~/.venv
source ~/.venv/bin/activate

pip install lxml polib

echo 'source ~/.venv/bin/activate' >> ~/.bashrc
