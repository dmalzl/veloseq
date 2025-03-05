#!/usr/bin/env python

import anndata as ad
import argparse as ap

def read_and_reindex(h5ad):
    adata = ad.read_h5ad(h5ad)
    adata.obs.index = [h5ad.split('.')[0]]
    return adata


parser = ap.ArgumentParser()
parser.add_argument(
    '--input',
    nargs = '+',
    help = 'list of input files to merge'
)
parser.add_argument(
    '--output',
    required = True,
    help = 'file to write the merged data to'
)
args = parser.parse_args()

adata = ad.concat(
    [
        read_and_reindex(h5ad)
        for h5ad
        in args.input
    ]
)

adata.layers['unspliced'] = adata.layers['nascent'].copy()
adata.layers['spliced'] = adata.layers['mature'].copy()
del adata.layers['mature'], adata.layers['nascent']

adata.write(args.output)
