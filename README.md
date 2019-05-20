# d3b_bic-seq2
CWL Implementation based on this tool http://compbio.med.harvard.edu/BIC-seq/ and this cluster implementation: https://github.com/ding-lab/BICSEQ2

## BIC-SEQ2 Workflow

### Introduction
Runs cnv tool following http://compbio.med.harvard.edu/BIC-seq/ and general workflow from https://github.com/ding-lab/BICSEQ2.  Params generally agreed upon through email correspondence with collaborating group.  Generates a `.CNV` merged file and tar ball with png illustration per chromosome.

#### NBICseq-norm
Version 0.2.4, normalizes read counts from count step
#### NBICseq-norm
Version 0.7.2, calculates copy number change based on normalized results.

### Usage

#### Inputs:
```yaml
inputs:
  input_tumor_align: {type: File, secondaryFiles: ['.crai']}
  input_normal_align: {type: File, secondaryFiles: ['.crai']}
  reference: {type: File, secondaryFiles: [.fai]}
  ref_chrs: {type: File, doc: "Tar gzipped per-chromosome fasta"}
  rlen: {type: int, doc: "Max read length allowed. Recommend max possible read len minus 1"}
  interval_list: {type: File, doc: "Can be bed or gatk interval_list"}
  output_basename: string
```

#### Suggested input files/values:
```text
reference: Homo_sapiens_assembly38.fasta
ref_chrs: GRCh38_everyChrs.tar.gz
rlen: 150
interval_list: GRCh38.d1.vd1.fa.150mer.merged.bed
```


#### Outputs:
```yaml
outputs:
  per_chrom_png: {type: File, outputSource: tar_per_chrom_results/per_chrom_png}
  merge_cnv_results: {type: File, outputSource: tar_per_chrom_results/merged_chrom_cnv}
```