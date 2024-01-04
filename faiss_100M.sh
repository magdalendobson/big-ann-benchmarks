#/bin/bash

python3.10 run.py --algorithm faiss-t1 --dataset bigann-100M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm faiss-t1-v2 --dataset bigann-100M --definitions artifact_eval.yaml --rebuild

python3.10 run.py --algorithm faiss-t1 --dataset msspacev-100M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm faiss-t1-v2 --dataset msspacev-100M --definitions artifact_eval.yaml --rebuild

python3.10 run.py --algorithm faiss-t1 --dataset text2image-100M --definitions artifact_eval.yaml --rebuild