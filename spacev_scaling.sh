#/bin/bash

#1M builds

python3.10 run.py --algorithm ParDiskANN --dataset msspacev-1M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHCNNG --dataset msspacev-1M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParPyNNDescent --dataset msspacev-1M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHNSW --dataset msspacev-1M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm faiss-t1 --dataset msspacev-1M --definitions artifact_eval.yaml --rebuild

#10M builds

python3.10 run.py --algorithm ParDiskANN --dataset msspacev-10M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHCNNG --dataset msspacev-10M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParPyNNDescent --dataset msspacev-10M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHNSW --dataset msspacev-10M --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm faiss-t1 --dataset msspacev-10M --definitions artifact_eval.yaml --rebuild


#1B builds (100M already done)

python3.10 run.py --algorithm ParDiskANN --dataset msspacev-1B --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHCNNG --dataset msspacev-1B --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParPyNNDescent --dataset msspacev-1B --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm ParHNSW --dataset msspacev-1B --definitions artifact_eval.yaml --rebuild
python3.10 run.py --algorithm faiss-t1 --dataset msspacev-1B --definitions artifact_eval.yaml --rebuild