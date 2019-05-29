cwlVersion: v1.0
class: CommandLineTool
id: gem_mappability
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'migbro/gem:pre3'
  - class: ResourceRequirement
    ramMin: 32000
    coresMin: 16
  - class: InlineJavascriptRequirement
baseCommand: [gem-mappability]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      -I $(inputs.gem_index.path)
      -l $(inputs.bp_len)
      -t 16
      -m 2
      -o $(inputs.gem_index.nameroot)_$(inputs.bp_len)

inputs:
  gem_index: {type: File, doc: ".gem index file"}
  bp_len: {type: int, doc: "bp length to generate mappability file for.  Corresponnds with max input read length"}
outputs:
  mappa_file:
    type: File
    outputBinding:
      glob: '*.mappability'
