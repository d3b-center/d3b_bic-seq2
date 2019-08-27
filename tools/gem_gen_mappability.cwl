cwlVersion: v1.0
class: CommandLineTool
id: gem_mappability
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'migbro/gem:pre3'
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 8000
    coresMin: $(inputs.threads)
baseCommand: [gem-mappability]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      -I $(inputs.gem_index.path)
      -l $(inputs.bp_len)
      -t $(inputs.threads)
      -m 2
      -o $(inputs.gem_index.nameroot)_$(inputs.bp_len)

inputs:
  gem_index: {type: File, doc: ".gem index file"}
  bp_len: {type: int, doc: "bp length to generate mappability file for.  Corresponds with max input read length"}
  threads:
    type: ['null', int]
    default: 4
outputs:
  mappa_file:
    type: File
    outputBinding:
      glob: '*.mappability'
