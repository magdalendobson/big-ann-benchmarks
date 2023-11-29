#!/bin/bash

#Comment out any thread counts that your machine does not have

# builds on 1 thread
python3.10 run.py --algorithm ParDiskANN --dataset msspacev-1M --definitions thread_1.yaml --rebuild
python3.10 run.py --algorithm ParHCNNG --dataset msspacev-1M --definitions thread_1.yaml --rebuild
python3.10 run.py --algorithm ParPyNNDescent --dataset msspacev-1M --definitions thread_1.yaml --rebuild
python3.10 run.py --algorithm ParHNSW --dataset msspacev-1M --definitions thread_1.yaml --rebuild

# builds on 2 threads
python3.10 run.py --algorithm ParDiskANN --dataset msspacev-1M --definitions thread_2.yaml --rebuild
python3.10 run.py --algorithm ParHCNNG --dataset msspacev-1M --definitions thread_2.yaml --rebuild
python3.10 run.py --algorithm ParPyNNDescent --dataset msspacev-1M --definitions thread_2.yaml --rebuild
python3.10 run.py --algorithm ParHNSW --dataset msspacev-1M --definitions thread_2.yaml --rebuild

# builds on 8 threads
python3.10 run.py --algorithm ParDiskANN --dataset msspacev-1M --definitions thread_8.yaml --rebuild
python3.10 run.py --algorithm ParHCNNG --dataset msspacev-1M --definitions thread_8.yaml --rebuild
python3.10 run.py --algorithm ParPyNNDescent --dataset msspacev-1M --definitions thread_8.yaml --rebuild
python3.10 run.py --algorithm ParHNSW --dataset msspacev-1M --definitions thread_8.yaml --rebuild

# builds on 16 threads
python3.10 run.py --algorithm ParDiskANN --dataset msspacev-1M --definitions thread_16.yaml --rebuild
python3.10 run.py --algorithm ParHCNNG --dataset msspacev-1M --definitions thread_16.yaml --rebuild
python3.10 run.py --algorithm ParPyNNDescent --dataset msspacev-1M --definitions thread_16.yaml --rebuild
python3.10 run.py --algorithm ParHNSW --dataset msspacev-1M --definitions thread_16.yaml --rebuild

# builds on 24 threads
python3.10 run.py --algorithm ParDiskANN --dataset msspacev-1M --definitions thread_24.yaml --rebuild
python3.10 run.py --algorithm ParHCNNG --dataset msspacev-1M --definitions thread_24.yaml --rebuild
python3.10 run.py --algorithm ParPyNNDescent --dataset msspacev-1M --definitions thread_24.yaml --rebuild
python3.10 run.py --algorithm ParHNSW --dataset msspacev-1M --definitions thread_24.yaml --rebuild

# builds on 32 threads
python3.10 run.py --algorithm ParDiskANN --dataset msspacev-1M --definitions thread_32.yaml --rebuild
python3.10 run.py --algorithm ParHCNNG --dataset msspacev-1M --definitions thread_32.yaml --rebuild
python3.10 run.py --algorithm ParPyNNDescent --dataset msspacev-1M --definitions thread_32.yaml --rebuild
python3.10 run.py --algorithm ParHNSW --dataset msspacev-1M --definitions thread_32.yaml --rebuild

# builds on 48 threads
python3.10 run.py --algorithm ParDiskANN --dataset msspacev-1M --definitions thread_48.yaml --rebuild
python3.10 run.py --algorithm ParHCNNG --dataset msspacev-1M --definitions thread_48.yaml --rebuild
python3.10 run.py --algorithm ParPyNNDescent --dataset msspacev-1M --definitions thread_1.yaml --rebuild
python3.10 run.py --algorithm ParHNSW --dataset msspacev-1M --definitions thread_48.yaml --rebuild

# builds on 64 threads
python3.10 run.py --algorithm ParDiskANN --dataset msspacev-1M --definitions thread_48.yaml --rebuild
python3.10 run.py --algorithm ParHCNNG --dataset msspacev-1M --definitions thread_48.yaml --rebuild
python3.10 run.py --algorithm ParPyNNDescent --dataset msspacev-1M --definitions thread_48.yaml --rebuild
python3.10 run.py --algorithm ParHNSW --dataset msspacev-1M --definitions thread_64.yaml --rebuild

# builds on 96 threads
python3.10 run.py --algorithm ParDiskANN --dataset msspacev-1M --definitions thread_96.yaml --rebuild
python3.10 run.py --algorithm ParHCNNG --dataset msspacev-1M --definitions thread_96.yaml --rebuild
python3.10 run.py --algorithm ParPyNNDescent --dataset msspacev-1M --definitions thread_96.yaml --rebuild
python3.10 run.py --algorithm ParHNSW --dataset msspacev-1M --definitions thread_96.yaml --rebuild
