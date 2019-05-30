cwlVersion: v1.0
class: CommandLineTool
id: gem_indexer
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'migbro/gem:pre3'
  - class: ResourceRequirement
    ramMin: 48000
    coresMin: 36
  - class: InlineJavascriptRequirement
baseCommand: ["/bin/bash", "-c"]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      set -eo pipefail

      for chrom in `seq 1 22` X Y; do
        echo "samtools faidx $(inputs.canonical_fasta.path) chr$chrom > chr$chrom.fa && gem-indexer -i chr$chrom.fa -T 4 -c dna -o chr$chrom" >> cmd_list.txt
      done

      cat cmd_list.txt | xargs -P 9 -ICMD sh -c "CMD"
inputs:
  canonical_fasta: {type: File, doc: "Fasta file with just chr1-22, XY"}
outputs:
  gem_index:
    type: File[]
    outputBinding:
      glob: '*.gem'
