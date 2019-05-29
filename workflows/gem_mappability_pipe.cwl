cwlVersion: v1.0
class: Workflow
id: gem_mappability_pipe
requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  canonical_fasta: {type: File, doc: "Fasta file with just chr1-22, XY"}
  bp_len: {type: int, doc: "bp length to generate mappability file for.  Corresponnds with max input read length"}

outputs:
  mappa_files: {type: 'File[]', outputSource: gem_gen_mappability/mappa_file}
  gem_files: {type: 'File[]', outputSource: gem_create_indices/gem_index}
steps:
  gem_create_indices:
    run: ../tools/gem_gen_index.cwl
    in:
      canonical_fasta: canonical_fasta
    out: [gem_index]
  gem_gen_mappability:
    run: ../tools/gem_gen_mappability.cwl
    in:
      gem_index: gem_create_indices/gem_index
      bp_len: bp_len
    scatter: gem_index
    out: [mappa_file]

$namespaces:
  sbg: https://sevenbridges.com
hints:
  - class: 'sbg:maxNumberOfParallelInstances'
    value: 16
