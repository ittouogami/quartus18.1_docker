FROM ubuntu16
LABEL maintainer "ittou <VYG07066@gmail.com>"
ENV DEBIAN_FRONTEND noninteractive
ENV ALTERA_VER="18.1"
ENV QSYS_ROOTDIR="/opt/Intel/intelFPGA_lite/$ALTERA_VER/quartus/sopc_builder/bin"
ENV PATH=/opt/Intel/intelFPGA_lite/$ALTERA_VER/quartus/bin:/opt/Intel/intelFPGA_lite/$ALTERA_VER/qsys/bin:/opt/Intel/intelFPGA_lite/$ALTERA_VER/quartus/sopc_builder/bin:/opt/Intel/intelFPGA_lite/$ALTERA_VER/modelsim_ase/linux:/opt/Intel/intelFPGA_lite/$ALTERA_VER/hls/bin:$PATH
ARG URIS=smb://192.168.103.223/Share/Quartus18.1/
ARG QUARTUS=QuartusLiteSetup-18.1.0.625-linux.run
ARG MAX10=max10-18.1.0.625.qdz
ARG MODELSIM=ModelSimSetup-18.1.0.625-linux.run
RUN mkdir /quartus-installer && \
  curl -u guest ${URIS}${QUARTUS} -o /quartus-installer/${QUARTUS} && \
  curl -u guest ${URIS}${MAX10} -o /quartus-installer/${MAX10} && \
  curl -u guest ${URIS}${MODELSIM} -o /quartus-installer/${MODELSIM} && \
  apt-get update && \
  apt-get -y -qq install sudo && \
  apt-get -y -qq install locales && locale-gen en_US.UTF-8 && \
  apt-get -y -qq install software-properties-common \
                           libglib2.0-0:amd64 \
                           libfreetype6:amd64 \
                           libsm6:amd64 \
                           libxrender1:amd64 \
                           libfontconfig1:amd64 \
                           libxext6:amd64 \
                           libpng12-0:amd64 \
                           xterm:amd64 && \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get -y -qq install libc6:i386 \
                           libncurses5:i386 \
                           libstdc++6:i386 \
                           libxft2:i386 \
                           libxext6:i386 && \
  apt-get autoclean && \
  apt-get autoremove && \
  chmod 755 /quartus-installer/${QUARTUS} && \
  chmod 755 /quartus-installer/${MODELSIM} && \
  rm -rf /var/lib/apt/lists/* && \
  /quartus-installer/${QUARTUS} --mode unattended --unattendedmodeui none --installdir /opt/Intel/intelFPGA_lite/18.1 --accept_eula 1 && \
  /quartus-installer/${MODELSIM} --mode unattended --unattendedmodeui none --installdir /opt/Intel/intelFPGA_lite/18.1 --accept_eula 1 && \
  sudo rm -rf /quartus-installer/

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash", "-l"]

