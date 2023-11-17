# ParANN: Scalable and Deterministic Parallel Graph-Based Algorithms for Approximate Nearest Neighbor Search

## Getting Started

We use the Big ANN Benchmarks repository to generate our plots. We have provided a branch of this repository using Zenodo; you can use it to install a branch of the ParlayANN library that was also uploaded using Zenodo, as well as the competitor algorithms. 

### Install

The only prerequisite is Python3.10 and Docker. All commands are assumed to be run in the top-level directory unless otherwise stated.

1. Download and unzip the repo: 
2. Run `pip install -r requirements_py3.10.txt` (Use `requirements_py38.txt` if you have Python 3.8.)
3. Install docker by following instructions [here](https://docs.docker.com/engine/install/ubuntu/).
You should also to follow the post-install steps for running docker in non-root user mode.
4. Install the necessary Docker images as follows:

```bash
python3.10 install.py --algorithm parlayann-artifact
python3.10 install.py --algorithm faissconda
```

### Datasets

The evaluation assumes that datasets are stored in the `data/` directory inside the main folder. You may want to use a symbolic link to a directory on an SSD depending on your memory constraints (this is discussed further in the Evaluation section). Download a small toy dataset using:

```bash
python3.10 create_dataset.py --dataset random-xs
```

### Toy Evaluation

Finally, run the algorithms on the toy dataset to confirm that they run as expected:

```bash
python3.10 run.py --algorithm ParDiskANN --dataset random-xs --definitions artifact_eval.yaml
python3.10 run.py --algorithm ParHCNNG --dataset random-xs --definitions artifact_eval.yaml
python3.10 run.py --algorithm ParPyNNDescent --dataset random-xs --definitions artifact_eval.yaml
python3.10 run.py --algorithm faiss-t1 --dataset random-xs --definitions artifact_eval.yaml
```

TODO add other algorithms
TODO add more than one search option to generate plots

Now, generate a plot of results:

```bash
sudo chmod -R 777 results/
python3.10 plot.py --dataset random-xs
```

The plot should look similar to the following image (numbers generated on a machine with 72 cores, so your performance may vary):

TODO add plot

## Proposed Evaluation

