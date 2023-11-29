#!/bin/bash

#bigann dataset
python3.10 run.py --algorithm ParDiskANN --dataset bigann-10M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHCNNG --dataset bigann-10M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParPyNNDescent --dataset bigann-10M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHNSW --dataset bigann-10M --definitions artifact_eval.yaml --rebuild

#spacev dataset
python3.10 run.py --algorithm ParDiskANN --dataset msspacev-10M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHCNNG --dataset msspacev-10M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParPyNNDescent --dataset msspacev-10M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHNSW --dataset msspacev-10M --definitions artifact_eval.yaml --rebuild

#text2image dataset
python3.10 run.py --algorithm ParDiskANN --dataset text2image-10M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHCNNG --dataset text2image-10M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParPyNNDescent --dataset text2image-10M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHNSW --dataset text2image-10M --definitions artifact_eval.yaml --rebuild