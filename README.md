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
  t_rlen: {type: int, doc: "Max read length allowed, tumor sample. Recommend max possible read len minus 1"}
  n_rlen: {type: int, doc: "Max read length allowed, normal sample. Recommend max possible read len minus 1"}
  t_interval_list: {type: File, doc: "Can be bed or gatk interval_list, used as mappability file for tumor"}
  n_interval_list: {type: File, doc: "Can be bed or gatk interval_list, used as mappability file for normal"}
  output_basename: string
```

#### Suggested input files/values:
```text
reference: Homo_sapiens_assembly38.fasta
ref_chrs: GRCh38_everyChrs.tar.gz
interval_list: GRCh38.d1.vd1.fa.150mer.merged.bed or hg38_100bp_gem_mm2_mappability.merged.bed
```


#### Outputs:
```yaml
outputs:
  per_chrom_png: {type: File, outputSource: tar_per_chrom_results/per_chrom_png}
  merge_cnv_results: {type: File, outputSource: tar_per_chrom_results/merged_chrom_cnv}
```

## GEM mappability file generation
In the event that you need to create mappability files, you can use these tools to do so.  The output is a merged and sorted bed file that one can use to seprate by chr, using only starts and ends as bic-seq2 prefers.  The workflow above already converts the bed into that format.

### Suggested Run Order

#### gem_mappability_pipe.cwl
Runs index and mappability steps.

Inputs:
```yaml
inputs:
  canonical_fasta: {type: File, doc: "Fasta file with just chr1-22, XY"}
  bp_len: {type: int, doc: "bp length to generate mappability file for.  Corresponds with max input read length"}

```
Outputs:
```yaml
outputs:
  mappa_files: {type: 'File[]', outputSource: gem_gen_mappability/mappa_file}
  gem_files: {type: 'File[]', outputSource: gem_create_indices/gem_index}

```

#### gem_gen_index.cwl
Uses above outupts to create merged bed mappability file

Inputs:
```yaml
inputs:
  gem_files: {type: 'File[]', doc: ".gem index file array"}
  mappa_files: {type: 'File[]', doc: "mappability output files"}
  output_basename: string
```
Outputs:
```yaml
outputs:
  converted_map:
    type: File
    outputBinding:
      glob: '$(inputs.output_basename).merged.bed'
```


### Tools descriptions

#### gem_gen_index
Takes a fasta file and fasta index file and creates per-chromosome gem indexes.  Could do as a whole, but next steps are cumbersome.  Best to split.

#### gem_gen_mappability
Uses gem indexes and base pair length to generate a mappability file, with mismatch set to 2 as recommended by collaborators.

#### gem_convert_map2bed
Uses above outputs and converts to a single bed file, filtering on mappability value of 1 only.



