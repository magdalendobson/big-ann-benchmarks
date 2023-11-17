from __future__ import absolute_import
import psutil
import os
import time
import numpy as np
import wrapper as pann

from neurips23.ood.base import BaseOODANN
from benchmark.datasets import DATASETS, download_accelerated

class vamana(BaseOODANN):
    def __init__(self, metric, index_params):
        self.name = "vamana"
        if (index_params.get("R")==None):
            print("Error: missing parameter R")
            return
        if (index_params.get("L")==None):
            print("Error: missing parameter L")
            return
        self._index_params = index_params
        self._metric = self.translate_dist_fn(metric)

        self.R = int(index_params.get("R"))
        self.L = int(index_params.get("L"))
        self.alpha = float(index_params.get("alpha", 1.0))
        self.two_pass = float(index_params.get("two_pass", False))

    def index_name(self):
        return f"R{self.R}_L{self.L}_alpha{self.alpha}"
    
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
            # choosing 1.2 for alpha but this is probably provided in index_params
            pann.build_vamana_index(self._metric, self.translate_dtype(ds.dtype), ds.get_dataset_fn(), index_dir, self.R, self.L, self.alpha, self.two_pass)
            end = time.time()
            print("Indexing time: ", end - start)
            print(f"Wrote index to {index_dir}")

        self.index = pann.load_index(self._metric, self.translate_dtype(ds.dtype), ds.get_dataset_fn(), index_dir, ds.nb, d)
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
                self.index = pann.load_index(self._metric, self.translate_dtype(ds.dtype), ds.get_dataset_fn(), index_dir, ds.nb, d)
                print("Index loaded")
                return True
            except:
                print("Index not found")
                return False
        else:
                print("Index not found")
                return False