process MERGE_ANNDATA {
    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"

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