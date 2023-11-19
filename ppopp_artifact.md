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
```

TODO add HNSW

Now, generate a plot of results:

```bash
sudo chmod -R 777 results/
python3.10 plot.py --dataset random-xs
```

The plot should look similar to the following image (numbers generated on a machine with 72 cores, so your performance may vary):

TODO add plot

## Proposed Evaluation

We present experimental results in Figures 1, 3, and 4 in our paper. Figure 1 shows a curve of in build times as the number of threads varies from 1 to 96. Figure 3 shows QPS/recall plots for our algorithms for billion size datasets. Figure 4 is a size scaling study that tracks various metrics as the size of the dataset increases. We consider the main results of our paper to be the speedup figures in Figure 1 and the QPS/recall plots in Figure 3. In particular, we do not consider the size scaling study in Figure 4 to be a main result, and we anticipate that the reviewer may not want to experiment with datasets larger than 10 million vectors, so we do not include instructions to reproduce this figure. 

Our paper presents results specifically on billion-size datasets. It took around 120 hours on a [TODO fill in machine] with 192 vCPUs to build all of the graphs, and requires around 1.5 terabytes of main memory. It additionally requires about 2 TB to store all the datasets, and then an additional 10 TB to store all the graph indices. We assume that the reviewer will not have the relevant time or resources for this evaluation. The evaluation for 100 million size took about 16 hours on a [TODO fill in machine] with 96 vCPUs to build each graph and requires about 150 GB of main memory as well as 1 TB storage. We assume that the reviewer may possibly be able to do the 100 million scale evaluation, but we also provide instructions to reproduce the results at the 10 million scale in case that is preferred (the memory requirements scale down by exactly a factor of 10 when going from 100 million to 10 million). 

In the next section, we describe how to reproduce the thread scaling results in Figure 1. Then, we provide scripts for reproducing the results in Figure 3 at either the 10 million or 100 million scale.

### Thread Scaling (Figure 1)

In Figure 1, we show speedup of build times relative to the original (i.e. not lock-free) algorithm on one thread. Since the artifact does not require the use of other researchers' code, we instead plot build times for our own implementations on the y-axis and number of threads on the x-axis. 

First, download the dataset:

```bash
python3.10 create_dataset.py --dataset msspacev-1M
```

The next script builds the graph for each algorithm on [1,2,8,16,24,32,48,64,96] threads. If your evaluation machine has fewer threads, you can access the script and comment out the lines corresponding to the thread counts you wish to exclude. Note that if you are monitoring thread usage using e.g. `htop`, some of the steps outside building (e.g. loading the dataset, saving and loading the graph, etc.) may still use all available threads. 

```bash
bash thread_scaling.sh
```

After the run concludes, use the following commands to generate the plot:

```bash
sudo chmod -R 777 results/
python3.10 plot.py --dataset msspacev-1M -x threads -y build --out results/threadscale_msspacev1M
```

You should find the plot in the `results` folder. It should be titled `threadscale_msspacev1M.png`

### Ten Million Scale QPS/Recall Plots (Figure 3)

First, download the datasets: 
```bash
python3.10 create_dataset.py --dataset [bigann-10M | msspacev-10M | text2image-10M]
```
The download of a file occasionally fails due to connectivity and needs to be repeated. Running the download multiple times will not download duplicates of the datasets, so just rerun the same command if you get any error messages.

Next, run each algorithm using the following script:
```bash
bash run_10M_builds.sh
```

After the run concludes, use the following commands to generate plots:

```bash
sudo chmod -R 777 results/
bash create_10M_plots.sh
```

Next, navigate to the `results/` folder. It should have generated three new QPS/recall plots, one for each dataset. 

### Hundred Million Scale QPS/Recall Plots (Figure 3)

The explanation for these instructions is exactly analogous to the instructions for 10M size datasets:

```bash
python3.10 create_dataset.py --dataset [bigann-100M | msspacev-100M | text2image-100M]
bash run_100M_builds.sh
sudo chmod -R 777 results/
bash create_100M_plots.sh
```

## Extending Functionality


