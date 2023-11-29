 ParANN: Scalable and Deterministic Parallel Graph-Based Algorithms for Approximate Nearest Neighbor Search

## Getting Started

We use the [Big ANN Benchmarks](https://github.com/harsha-simhadri/big-ann-benchmarks/tree/main) repository to generate our plots. We have uploaded a fork of this repository to Zenodo; you can use it to install a branch of our library that was also uploaded using Zenodo.

### Install

The only prerequisite is Python3.10 and Docker. All commands are assumed to be run in the top-level directory unless otherwise stated. You may wish to use a conda environment for python commands.

1. Download and unzip the repo: 
2. Run `pip install -r requirements_py3.10.txt` 
3. Install docker by following instructions [here](https://docs.docker.com/engine/install/ubuntu/).
You should also to follow the post-install steps for running docker in non-root user mode.
4. Install the necessary Docker images as follows:

```bash
python3.10 install.py --algorithm parlayann-artifact
```

### Datasets

The evaluation assumes that datasets are stored in the `data/` directory inside the main folder. You should use a symbolic link to a directory on an SSD depending on your memory constraints (this is discussed further in the Evaluation section, note that the resulting saved graphs will also be written to this folder). Download a small toy dataset using:

```bash
python3.10 create_dataset.py --dataset random-xs
```

### Toy Evaluation

Finally, run the algorithms on the toy dataset to confirm that they run as expected. The `run.py` file builds a nearest neighbor graph (as described in Section 3 of our paper) and queries it, recording the results for later analysis. 

```bash
python3.10 run.py --algorithm ParDiskANN --dataset random-xs --definitions artifact_eval.yaml
python3.10 run.py --algorithm ParHCNNG --dataset random-xs --definitions artifact_eval.yaml
python3.10 run.py --algorithm ParPyNNDescent --dataset random-xs --definitions artifact_eval.yaml
python3.10 run.py --algorithm ParHNSW --dataset random-xs --definitions artifact_eval.yaml
```

Now, generate a plot of results:

```bash
sudo chmod -R 777 results/
python3.10 plot.py --dataset random-xs
```

The plot can be found in `results/random-xs.png`.

## Proposed Evaluation

We present experimental results in Figures 1, 3, and 4 in our paper. Figure 1 shows a curve of in build times as the number of threads varies from 1 to 96. Figure 3 shows QPS/recall plots for our algorithms for billion size datasets. Figure 4 is a size scaling study that tracks various metrics as the size of the dataset increases from 1 million to 1 billion. We assume that the reviewer will not have the resources to generate this graph as it requires multiple evaluations at both the 100 million and billion scale; the data points for the 10 million scale are observable from the plots corresponding to Figure 3. 

Our paper presents results specifically on billion-size datasets. It took around 120 hours on an Azure Msv2 with 192 vCPUs to build all of the graphs, and requires around 1.5 terabytes of main memory. It additionally requires about 2 TB to store all the datasets, and then an additional 10 TB to store all the graph indices. We assume that the reviewer will not have the relevant time or resources for this evaluation. The evaluation for 100 million size took about 16 hours on an Azure ev5 with 96 vCPUs to build each graph and requires about 150 GB of main memory as well as 1 TB storage. We assume that the reviewer may possibly be able to do the 100 million scale evaluation, but we also provide instructions to reproduce the results at the 10 million scale in case that is preferred (the memory requirements scale down by exactly a factor of 10 when going from 100 million to 10 million). 

In the next section, we describe how to reproduce the thread scaling results in Figure 1. Then, we provide scripts for reproducing the results in Figure 3 at either the 10 million or 100 million scale.

We suggest a minimum hardware requirement of a 16-32 core machine with at least 20 GB main memory and at least 100 GB free SSD storage space. We also require the evaluator to have sudo access to the machine. If you have less storage space (say around 30 GB) it may still be possible to run the evaluation by deleting graph files as they are generated instead of storing them. We are happy to discuss how to do this if this is your scenario.

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
python3.10 plot.py --dataset msspacev-1M -x threads -y build --out results/threadscale_msspacev1M -Y log
```

You should find the plot in the `results` folder. It should be titled `threadscale_msspacev1M.png`

### Ten Million Scale QPS/Recall Plots (Figure 3)

First, download the datasets: 
```bash
python3.10 create_dataset.py --dataset bigann-10M 
python3.10 create_dataset.py --dataset msspacev-10M 
python3.10 create_dataset.py --dataset text2image-10M
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
python3.10 create_dataset.py --dataset bigann-100M
python3.10 create_dataset.py --dataset msspacev-100M
python3.10 create_dataset.py --dataset text2image-100M
bash run_100M_builds.sh
sudo chmod -R 777 results/
bash create_100M_plots.sh
```

You might also wish to run a single build algorithm on one dataset instead of all combinations. Here is an example of the command to do this for bigann-100M for ParDiskANN:

```bash
python3.10 create_dataset.py --dataset bigann-100M 
python3.10 run.py --algorithm ParDiskANN --dataset bigann-100M --definitions artifact_eval.yaml --rebuild
sudo chmod -R 777 results/
python3.10 plot.py --dataset bigann-100M --y-scale log --out results/QPS_bigann_100M
```

## Extending Functionality

Here we describe how to modify the search and build parameters of each algorithm and mention some other datasets that they can be run on if desired. The meanings of these parameters are discussed in detail in our paper, and we provide pointers to the relevant sections where applicable.

The search options for each dataset are configured in `artifact_eval.yaml`; you can use this file to change parameters and add parameters for other datasets. We provide an explicit example at the end of the section.

## Search Parameters

The search parameters are divided by those for single-layer graphs and those for multi-layer graphs, and are described in Appendix B of our paper. The parameters for single layer graphs are as follows:

1. **Ls** (`long`): the beam width for use during searching. Must be set at least $k$. Controls the number of candidate neighbors retained at any point in the search and is for the most part the chief determinant of accuracy and speed of the search. A higher beam produces a slower but more accurate search. Typically set from 10-1000.
2. **visit** (`long`): controls the maximum number of graph vertices visited during the beam search. This is useful for low accuracy searches, because for most inputs, even the minimum beam value reaches recall around 80%. Constraining the number of vertices that can be visited provides a way to reach lower recall very quickly. Typically set between 3-20. 

## Build Parameters

The build parameters are described in detail in Appendix B of our paper. Here we provide an overview of parameter names and suggested ranges.

The build parameters for ParDiskANN are as follows:

1. **R** (`long`): the degree bound. Typically between 32 and 128.
2. **L** (`long`): the beam width to use when building the graph. Should be set at least 30% higher than $R$, and up to 500.
3. **alpha** (`double`): the pruning parameter. Should be set at 1.0 for similarity measures that are not metrics (e.g. maximum inner product), and between 1.0 and 1.4 for metric spaces. 
4. **two_pass** (`bool`): optional argument that allows the user to build the graph with two passes or just one (two passes approximately doubles the build time, but provides higher accuracy).

The build parameters for ParHCNNG are as follows:

1. **mst_deg** (`long`): the degree bound of the graph built by each individual cluster tree. Almost always set to 3.
2. **num_clusters** (`long`): the number of cluster trees. Set between 20 and 50.
3. **cluster_size** (`long`): the leaf size of each cluster tree. Almost always set to 1000.

The build parameters for ParPyNNDescent are as follows:

1. **R** (`long`): the graph degree bound. Typically set from 40-60.
2. **num_clusters** (`long`): the number of cluster trees to use when initializing the graph. Typically around 10.
3. **cluster_size** (`long`): the leaf size of the cluster trees. Typically 100-1000.
4. **alpha** (`double`): the pruning parameter for the final pruning step. Typically 1.2 for metric spaces, and 1.0 for non-metric spaces.
5. **delta** (`double`): the early stopping parameter for the nnDescent process. Almost always set to .05.

The build parameters for ParHNSW are as follows:

1. **m** (`long`): the degree bound. Typically between 16 and 64. The graph at the bottom layer (layer0) has the degree bound of $2m$ while graphs at upper layers have degree bound of $m$.
2. **efc** (`long`): the beam width to use when building the graph. Should be set at least $2.5R$, and up to 500.
3. **alpha** (`double`): the pruning parameter. Should be set between 1.0 and 1.15 for similarity measures that are not metrics (e.g. maximum inner product), and between 0.8 and 1.0 for metric spaces. 
4. **ml** (`double`): optional argument to control the number of layers (height). Increasing $ml$ results in more layers which increases the build time but potentially improve the query performance; however, improper settings of $ml$ (too high or too low) can incur much work of query thus impacting the query performance. It should be set around $1/log~m$.

## Other Datasets

Two other datasets are available to download through this repository; other datasets can be added by implementing the required class in `benchmarks/datasets.py`. The two datasets, Yandex DEEP and Microsoft Turing-ANNS, are described [here](https://big-ann-benchmarks.com/neurips21.html). They are available in 10M, 100M, and 1B slices and, like the other datasets, come with precomputed ground truth. 

## Example

The entry in the .yaml file for MSSPACEV-1M for ParDiskANN is as follows:

```yaml
msspacev-1M:
    ParDiskANN:
      docker-tag: billion-scale-benchmark-parlayann-artifact
      module: benchmark.algorithms.vamana
      constructor: vamana
      base-args: ["@metric"]
      run-groups:
        base:
          args: |
              [{"R":64, "L":128, "alpha":1.2, "two_pass":0}]
          query-args: |
            [{"Ls":10, "visit":3},
            {"Ls":10, "visit":5},
            {"Ls":10, "visit":8},
            {"Ls":10, "visit":12},
            {"Ls":10, "visit":15},
            {"Ls":15},
            {"Ls":20},
            {"Ls":30},
            {"Ls":40},
            {"Ls":50},
            {"Ls":60},
            {"Ls":75},
            {"Ls":100},
            {"Ls":150},
            {"Ls":200},
            {"Ls":400},
            {"Ls":500},
            {"Ls":1000}]
```

The number of threads is automatically set to the maximum number in your OS, but you can change it by modifying the build arguments by adding the parameter `T`: use `[{"R":64, "L":128, "alpha":1.2, "two_pass":0, "T":8}]` to run on 8 threads, for example. The rest of the parameters are as described in the previous section; the `args` section refers to the build arguments, and the `query-args` section refers to the query arguments. For other datasets you can add an additional entry to the .yaml file. 

You can plot any new variants using the plotting commands in this README, or by looking at the plotting commands in `create_10M_plots.sh`. You can also export statistics such as recall and distance computations to a CSV instead of plotting by using the command:

```bash
python3.10 data_export.py --out res.csv
```