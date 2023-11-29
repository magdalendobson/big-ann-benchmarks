from __future__ import absolute_import
import psutil
import os
import time
import numpy as np
import wrapper as pann

from neurips23.ood.base import BaseOODANN
from benchmark.datasets import DATASETS, download_accelerated

class hnsw(BaseOODANN):
    def __init__(self, metric, index_params):
        self.name = "hnsw"
        if (index_params.get("m")==None):
            print("Error: missing parameter m")
            return
        if (index_params.get("efc")==None):
            print("Error: missing parameter efc")
            return
        self._index_params = index_params
        self._metric = self.translate_dist_fn(metric)

        self.m = int(index_params.get("m"))
        self.efc = int(index_params.get("efc"))
        self.alpha = float(index_params.get("alpha", 1.0))
        self.ml = float(index_params.get("ml", 0.36))
        default_threads = os.cpu_count()
        threads = int(index_params.get("T", default_threads))
        self.threads = threads
        os.environ['PARLAY_NUM_THREADS'] = str(min(threads, os.cpu_count()))
        print("Threads: ", threads)
        print(os.environ.get('PARLAY_NUM_THREADS'))

    def index_name(self):
        return f"m{self.m}_efc{self.efc}_ml{self.ml}_alpha{self.alpha}_threads{self.threads}"
    
    def create_index_dir(self, dataset):
        index_dir = os.path.join(os.getcwd(), "data", "indices")
        os.makedirs(index_dir, mode=0o777, exist_ok=True)
        index_dir = os.path.join(index_dir, 'vamana')
        os.makedirs(index_dir, mode=0o777, exist_ok=True)
        index_dir = os.path.join(index_dir, dataset.short_name())
        os.makedirs(index_dir, mode=0o777, exist_ok=True)
        index_dir = os.path.join(index_dir, self.index_name())
        os.makedirs(index_dir, mode=0o777, exist_ok=True)
        return os.path.join(index_dir, self.index_name())
    
    def translate_dist_fn(self, metric):
        if metric == 'euclidean':
            return 'Euclidian'
        elif metric == 'ip':
            return 'mips'
        else:
            raise Exception('Invalid metric')
        
    def translate_dtype(self, dtype:str):
        if dtype == 'float32':
            return 'float'
        else:
            return dtype
        
    def fit(self, dataset):
        """
        Build the index for the data points given in dataset name.
        """
        ds = DATASETS[dataset]()
        d = ds.d

        index_dir = self.create_index_dir(ds)

        if hasattr(self, 'index'):
            print("Index already exists")
            return
        else:
            start = time.time()
            # ds.ds_fn is the name of the dataset file but probably needs a prefix
            # choosing 0.82 for alpha but this is probably provided in index_params
            pann.build_hnsw_index(self._metric, self.translate_dtype(ds.dtype), ds.get_dataset_fn(), index_dir, self.m, self.efc, self.ml, self.alpha)
            end = time.time()
            print("Indexing time: ", end - start)
            print(f"Wrote index to {index_dir}")

        self.index = pann.load_index(self._metric, self.translate_dtype(ds.dtype), ds.get_dataset_fn(), index_dir, ds.nb, d, True)
        print("Index loaded")

    def query(self, X, k):
        nq, d = X.shape
        self.res, self.query_dists = self.index.batch_search(X, nq, k, self.Ls, self.visit)

    def set_query_arguments(self, query_args):
        self._query_args = query_args
        self.Ls = 0 if query_args.get("Ls") is None else query_args.get("Ls")
        self.visit = -1 if query_args.get("visit") is None else query_args.get("visit")
        print("visit limit: ", self.visit)

    def load_index(self, dataset):
        ds = DATASETS[dataset]()
        d = ds.d
        index_dir = self.create_index_dir(ds)

        print("Trying to load...")

        try:
            file_size = os.path.getsize(index_dir)
            print(f"File Size in Bytes is {file_size}")
        except FileNotFoundError:
            file_size = 0
            print("File not found.")

        if(file_size != 0):
            try:
                self.index = pann.load_index(self._metric, self.translate_dtype(ds.dtype), ds.get_dataset_fn(), index_dir, ds.nb, d, True)
                print("Index loaded")
                return True
            except:
                print("Index not found")
                return False
        else:
                print("Index not found")
                return False
