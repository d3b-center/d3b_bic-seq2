cwlVersion: v1.0
class: CommandLineTool
id: gem_convert_map2bed
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'migbro/gem:pre3'
  - class: ResourceRequirement
    ramMin: 16000
    coresMin: 8
  - class: InlineJavascriptRequirement
baseCommand: ["/bin/bash", "-c"]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      set -eo pipefail

      ${
          var cmd = '';
          var in_len = inputs.gem_files.length;
          var gem_dict = {};
          var mappa_dict = {};
          var keys = [];
          for (var i = 0; i < in_len; i++){
              var gem_chr = inputs.gem_files[i].nameroot;
              keys.push(gem_chr)
              var mappa_chr = inputs.mappa_files[i].nameroot.split("_")[0];
              gem_dict[gem_chr] = inputs.gem_files[i];
              mappa_dict[mappa_chr] = inputs.mappa_files[i];
          }
          for (var i = 0; i < in_len; i++){
              var cur_gem = gem_dict[keys[i]].path;
              var mappa_path = mappa_dict[keys[i]].path;
              var mappa_nameroot = mappa_dict[keys[i]].nameroot;
              cmd += "echo \"gem-2-wig -I " + cur_gem + " -i " + mappa_path + " -o " + mappa_nameroot + " && \
              wigToBigWig " + mappa_nameroot + ".wig " + mappa_nameroot + ".sizes " + mappa_nameroot + ".bw && \
              bigWigToBedGraph " + mappa_nameroot + ".bw " + mappa_nameroot + ".bedGraph && \
              grep -E '\t1$' " + mappa_nameroot + ".bedGraph | cut -f 1-3 > " + mappa_nameroot + ".bed\" >> cmd_list.txt;"
          }
          return cmd;
      }

      cat cmd_list.txt | xargs -P 8 -ICMD sh -c "CMD"

      cat *chr*.bed | bedtools sort | bedtools merge > $(inputs.output_basename).merged.bed


inputs:
  gem_files: {type: 'File[]', doc: ".gem index file array"}
  mappa_files: {type: 'File[]', doc: "mappability output files"}
  output_basename: string
outputs:
  converted_map:
    type: File
    outputBinding:
      glob: '$(inputs.output_basename).merged.bed'
