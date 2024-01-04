#/bin/bash

#TODO scp the bigann gt for 1M

python3.10 run.py --algorithm ParDiskANN --dataset bigann-1M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHCNNG --dataset bigann-1M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParPyNNDescent --dataset bigann-1M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHNSW --dataset bigann-1M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm faiss-t1 --dataset bigann-1M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm faiss-t1-v2 --dataset bigann-1M --definitions artifact_eval.yaml --rebuild