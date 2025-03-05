include { KALLISTO_BUSTOOLS_COUNT as COUNT  } from '../../../modules/local/kb/count.nf'
include { MERGE_ANNDATA                     } from '../../../modules/local/kb/merge.nf'

workflow KALLISTO_BUSTOOLS {
    take:
    reads
    index

    main:

    COUNT (
        reads,
        index
    )

    MERGE_ANNDATA (
        COUNT.out.h5ad.collect { it[1].flatten() }
    )
    
    emit:
    h5ad = MERGE_ANNDATA.out.h5ad
}