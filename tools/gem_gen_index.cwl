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
baseCommand: [gem-indexer]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      -i $(inputs.canonical_fasta.path)
      -T 36
      -c dna
      -o $(inputs.canonical_fasta.nameroot)

inputs:
  canonical_fasta: {type: File, doc: "Fasta file with just chr1-22, XY"}
outputs:
  gem_index:
    type: File
    outputBinding:
      glob: '*.gem'
