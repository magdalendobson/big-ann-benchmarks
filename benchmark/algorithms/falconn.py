from __future__ import absolute_import
import psutil
import os
import time
import numpy as np
import falconn as fc

from neurips23.ood.base import BaseOODANN
from benchmark.datasets import DATASETS, download_accelerated

class falconn(BaseOODANN):
    def __init__(self, metric, index_params):
        self.name = "falconn"

        self._index_params = index_params
        self._metric = self.translate_dist_fn(metric)

        self.k = index_params.get("k")
        self.rot = index_params.get("rot")
        self.l = index_params.get("l")

        default_threads = os.cpu_count()
        threads = int(index_params.get("T", default_threads))
        self.threads = threads
        self.stats = {}
        os.environ['PARLAY_NUM_THREADS'] = str(min(threads, os.cpu_count()))
        print("Threads: ", threads)
        print(os.environ.get('PARLAY_NUM_THREADS'))

    def translate_dist_fn(self, metric):
        if metric == 'euclidean':
            return fc.DistanceFunction.EuclideanSquared
        elif metric == 'ip':
            return fc.DistanceFunction.NegativeInnerProduct
        else:
            raise Exception('Invalid metric')

    def fit(self, dataset):
        """
        Build the index for the data points given in dataset name.
        """
        ds = DATASETS[dataset]()
        ds_filename = ds.get_dataset_fn()

        meta_data = np.fromfile(ds_filename, dtype=np.uint32, count=2)
        num_pts, dim = meta_data[0], meta_data[1]
        print(f"Dataset loaded [{num_pts}, {dim}]")

        # skip meta_data
        coords = np.fromfile(ds_filename, dtype=ds.dtype, offset=8).astype(np.float32).reshape(num_pts,dim)

        params = fc.get_default_parameters(num_pts, dim, self._metric, True)
        if self.k is not None:
            params.k = int(self.k)
        if self.rot is not None:
            params.num_rotations = int(self.rot)
        if self.l is not None:
            params.l = int(self.l)

        self.index = fc.LSHIndex(params)
        self.index.setup(coords)
        self.build_params = params
        print("LSH tables are created")


    def query(self, X, k):
        # qobj = self.index.construct_query_object(self.num_probes, self.max_num_cand)
        qpool = self.index.construct_query_pool(self.num_probes, self.max_num_cand)

        nq, d = X.shape
        """
        self.res = np.zeros((nq, k))

        for i in range(nq):
            self.res[i] = qpool.find_k_nearest_neighbors(X[i].astype(np.float32), k)
        """
        # print("===== start query =====")
        res, total_dist_cmps = qpool.find_knn_batch(X.astype(np.float32), k);
        self.res = np.array(res)
        self.stats["dist_comps"] = total_dist_cmps
        self.stats["mean_dist_comps"] = total_dist_cmps/nq

    # def get_additional(self):
        # return self.stats

    def set_query_arguments(self, query_args):
        self._query_args = query_args
        if query_args.get("num_probes") is None:
            raise Exception("Missing num_probes for queries")
        if query_args.get("max_num_cand") is None:
            raise Exception("Missing max_num_cand for queries")

        self.num_probes = max(self.build_params.l, int(query_args.get("num_probes")))
        self.max_num_cand= int(query_args.get("max_num_cand"))

    def load_index(self, dataset):
        print("FALCONN does not support to save LSH tables")
        return False
