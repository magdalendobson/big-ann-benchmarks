#!/bin/bash

#bigann dataset
python3.10 run.py --algorithm ParDiskANN --dataset bigann-1B --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHCNNG --dataset bigann-1B --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm faiss-t1 --dataset bigann-1B --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHNSW --dataset bigann-1B --definitions artifact_eval.yaml --rebuild


#spacev dataset
python3.10 run.py --algorithm ParDiskANN --dataset msspacev-1B --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHCNNG --dataset msspacev-1B --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm faiss-t1 --dataset msspacev-1B --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHNSW --dataset msspacev-1B --definitions artifact_eval.yaml --rebuild


#text2image dataset
python3.10 run.py --algorithm ParDiskANN --dataset text2image-1B --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHCNNG --dataset text2image-1B --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm faiss-t1 --dataset text2image-1B --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHNSW --dataset text2image-1B --definitions artifact_eval.yaml --rebuild