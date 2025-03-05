process KALLISTO_BUSTOOLS_COUNT {
    tag "$meta.id"
    label 'process_medium'
    clusterOptions '--constraint=avx2,amd' // this is to avoid illegal instruction error when streaming extension does not match binary

    conda "${moduleDir}/environment.yml"

    input:
    tuple val(meta), path(reads, stageAs: "input*/*")
    path(index)

    output:
    tuple val(meta), path('*h5ad'), emit: h5ad

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def reads1 = [], reads2 = []
    def parity = meta.single_end ? 'single' : 'paired'
    meta.single_end ? [reads].flatten().each{reads1 << it} : reads.eachWithIndex{ v, ix -> ( ix & 1 ? reads2 : reads1) << v }
    """
    kb count \\
            --h5ad \\
            -i ${index}/index.idx \\
            -g ${index}/t2g.txt \\
            -x bulk \\
            -o ${prefix} \\
            -c1 ${index}/cdna.txt \\
            -c2 ${index}/nascent.txt \\
            --workflow lamanno \\
            --verbose \\
            -t ${task.cpus} \\
            --gene-name \\
            --strand ${meta.strandedness} \\
            --parity ${parity} \\
            ${reads1.join(' ')} ${reads2.join(' ')}

    mv ${prefix}/counts_unfiltered/adata.h5ad ${prefix}.h5ad
    rm -r ${prefix}
    """
}