cwlVersion: v1.0
class: CommandLineTool
id: gem_mappability
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'migbro/gem:pre3'
  - class: ResourceRequirement
    ramMin: 48000
    coresMin: 36
  - class: InlineJavascriptRequirement
baseCommand: [/GEM-binaries-Linux-x86_64-core_i3-20130406-045632/bin/gem-mappability]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      -I $(inputs.gem_index.path)
      -l $(inputs.bp_len)
      -t 36
      -o $(inputs.gem_index.nameroot)_$(inputs.bp_len)

inputs:
  gem_index: {type: File, doc: ".gem index file"}
  bp_len: {type: int, doc: "bp length to generate mappability file for.  Corresponnds with max input read length"}
outputs:
  mappa_file:
    type: File[]
    outputBinding:
      glob: '*.mappability'
