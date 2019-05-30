cwlVersion: v1.0
class: Workflow
id: bic-seq2-input-prep
requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  input_tumor_align: {type: File, secondaryFiles: ['.crai']}
  input_normal_align: {type: File, secondaryFiles: ['.crai']}
  reference: {type: File, secondaryFiles: [.fai]}
  ref_chrs: {type: File, doc: "Tar gzipped per-chromosome fasta"}
  t_rlen: {type: int, doc: "Max read length allowed, tumor sample. Recommend max possible read len minus 1"}
  n_rlen: {type: int, doc: "Max read length allowed, normal sample. Recommend max possible read len minus 1"}
  t_interval_list: {type: File, doc: "Can be bed or gatk interval_list, used as mappability file for tumor"}
  n_interval_list: {type: File, doc: "Can be bed or gatk interval_list, used as mappability file for normal"}

outputs:
  tumor_seq: {type: 'File[]', outputSource: bic-seq2_prep_tumor_inputs/seq_file}
  normal_seq: {type: 'File[]', outputSource: bic-seq2_prep_normal_inputs/seq_file}
  t_map_file: {type: 'File[]', outputSource: ubuntu_prep_tumor_intervals/map_file}
  n_map_file: {type: 'File[]', outputSource: ubuntu_prep_normal_intervals/map_file}
  chr_fa: {type: 'File[]', outputSource: ubuntu_prep_fasta/chr_fa}
steps:
  bic-seq2_prep_tumor_inputs:
    run: ../tools/bic-seq2_prep_input.cwl
    in:
      input_align: input_tumor_align
      reference: reference
      stype:
        valueFrom: ${return "tumor"}
      rlen: t_rlen
    out: [seq_file]
  bic-seq2_prep_normal_inputs:
    run: ../tools/bic-seq2_prep_input.cwl
    in:
      input_align: input_normal_align
      reference: reference
      stype:
        valueFrom: ${return "normal"}
      rlen: n_rlen
    out: [seq_file]
  ubuntu_prep_tumor_intervals:
    run: ../tools/ubuntu_prep_intvls.cwl
    in:
      interval_list: t_interval_list
      ref_chrs: ref_chrs
    out: [map_file]
  ubuntu_prep_normal_intervals:
    run: ../tools/ubuntu_prep_intvls.cwl
    in:
      interval_list: n_interval_list
      ref_chrs: ref_chrs
    out: [map_file]
  ubuntu_prep_fasta:
    run: ../tools/ubuntu_prep_fa.cwl
    in:
      ref_chrs: ref_chrs
    out: [chr_fa]

$namespaces:
  sbg: https://sevenbridges.com
hints:
  - class: 'sbg:maxNumberOfParallelInstances'
    value: 2
