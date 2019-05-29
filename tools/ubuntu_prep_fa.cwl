cwlVersion: v1.0
class: CommandLineTool
id: prep_fasta_files
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'ubuntu:18.04'
  - class: ResourceRequirement
    ramMin: 2000
    coresMin: 2
  - class: InlineJavascriptRequirement
baseCommand: [tar, -xzf]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      $(inputs.ref_chrs.path)

      rm $(inputs.ref_chrs.nameroot.substring(0,(inputs.ref_chrs.nameroot.length-4)))/chrM.fa
inputs:
  ref_chrs: {type: File, doc: "Tar gzipped per-chromosome fasta"}
outputs:
  chr_fa:
    type: File[]
    outputBinding:
      glob: "$(inputs.ref_chrs.nameroot.substring(0,(inputs.ref_chrs.nameroot.length-4)))/*.fa"
