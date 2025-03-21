process MERGE_ANNDATA {
    tag "merge"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "docker.io/dmalzl/veloseq:1.0.1"

    input:
    path(h5ad)

    output:
    path('results.h5ad'), emit: h5ad

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    merge_anndata.py \\
        --input $h5ad \\
        --output results.h5ad
    """
}