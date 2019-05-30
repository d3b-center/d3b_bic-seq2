FROM ubuntu:18.04
LABEL maintainer="Miguel Brown (brownm28@email.chop.edu)"

ENV PATH="/GEM-binaries-Linux-x86_64-core_i3-20130406-045632/bin:${PATH}"

RUN apt update && apt install -y wget samtools bedtools && \
wget -q https://sourceforge.net/projects/gemlibrary/files/gem-library/Binary%20pre-release%203/GEM-binaries-Linux-x86_64-core_i3-20130406-045632.tbz2/download && \
wget -q http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/bigWigToBedGraph && wget -q http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/wigToBigWig && \
mv download GEM-binaries-Linux-x86_64-core_i3-20130406-045632.tbz2 && tar -xjf GEM-binaries-Linux-x86_64-core_i3-20130406-045632.tbz2 && rm GEM-binaries-Linux-x86_64-core_i3-20130406-045632.tbz2 && \
mv bigWigToBedGraph /usr/local/bin && mv wigToBigWig /usr/local/bin && chmod -R 755 /usr/local/bin && \
apt remove -y wget