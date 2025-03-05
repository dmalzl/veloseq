process KALLISTO_BUSTOOLS_INDEX {
    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"

    input:
    val(genome)

    output:
    path('index'), emit: index

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    mkdir index

    kb ref \\
        --workflow=nac \\
        -d $genome \\
        -i index/index.idx \\
        -g index/t2g.txt \
        -c1 index/cdna.txt 
        -c2 index/nascent.txt
    """
}