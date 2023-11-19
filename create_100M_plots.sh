#!/bin/bash

python3.10 plot.py --dataset bigann-100M --y-scale log --out results/QPS_bigann_100M
python3.10 plot.py --dataset msspacev-100M --y-scale log --out results/QPS_msspacev_100M
python3.10 plot.py --dataset text2image-100M --y-scale log --out results/QPS_text2image_100M