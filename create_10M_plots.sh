#!/bin/bash

python3.10 plot.py --dataset bigann-10M --y-scale log --out results/QPS_bigann_10M
python3.10 plot.py --dataset msspacev-10M --y-scale log --out results/QPS_msspacev_10M
python3.10 plot.py --dataset text2image-10M --y-scale log --out results/QPS_text2image_10M