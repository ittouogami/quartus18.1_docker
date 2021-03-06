FROM ubuntu16
LABEL maintainer "ittou <VYG07066@gmail.com>"
ENV DEBIAN_FRONTEND noninteractive
ARG ALTERA_VER=18.1
ARG IP
ENV INTELFPGA_TOOLDIR="/opt/Intel/intelFPGA_lite/${ALTERA_VER}"
ENV MODELSIM_DIR="${INTELFPGA_TOOLDIR}/modelsim_ase"
ENV QUARTUS_ROOTDIR="${INTELFPGA_TOOLDIR}/quartus"
ENV QSYS_ROOTDIR="${QUARTUS_ROOTDIR}/sopc_builder/bin"
ENV QUARTUS_ROOTDIR_OVERRIDE=${QUARTUS_ROOTDIR}
ENV CPLUS_INCLUDE_PATH=/usr/include/c++/4.4.7:/usr/include/c++/4.4.7/x86_64-linux-gnu
ENV PATH=/opt/Intel/intelFPGA_lite/$ALTERA_VER/quartus/bin:/opt/Intel/intelFPGA_lite/$ALTERA_VER/qsys/bin:/opt/Intel/intelFPGA_lite/$ALTERA_VER/quartus/sopc_builder/bin:/opt/Intel/intelFPGA_lite/$ALTERA_VER/modelsim_ase/linux:/opt/Intel/intelFPGA_lite/$ALTERA_VER/hls/bin:$PATH
ARG URIS=smb://${IP}/Share/Quartus${ALTERA_VER}/
ARG QUARTUS=QuartusLiteSetup-18.1.0.625-linux.run
ARG MAX10=max10-18.1.0.625.qdz
ARG MODELSIM=ModelSimSetup-18.1.0.625-linux.run
RUN mkdir /quartus-installer && \
  apt-get update && \
  apt-get -y -qq install sudo && \
  apt-get -y -qq install locales && locale-gen en_US.UTF-8 && \
  apt-get -y -qq install software-properties-common \
                           libglib2.0-0 \
                           libfreetype6 \
                           libsm6 \
                           libxrender1 \
                           libfontconfig1 \
                           libxext6 \
                           libpng12-0 \
                           xterm \
                           gcc \
                           g++ \
                           smbclient && \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get -y -qq install libc6:i386 \
                           libncurses5:i386 \
                           libstdc++6:i386 \
                           libxft2:i386 \
                           libxext6:i386 && \
  add-apt-repository "deb http://jp.archive.ubuntu.com/ubuntu/ trusty main universe" && \
  add-apt-repository "deb http://jp.archive.ubuntu.com/ubuntu/ trusty-updates main universe" && \
  apt-get update && \
  apt-get -y -qq install g++-4.4 \
                       g++-4.4-multilib && \
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 10 --slave /usr/bin/g++ g++ /usr/bin/g++-5 && \
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.4 5 --slave /usr/bin/g++ g++ /usr/bin/g++-4.4 && \
  update-alternatives --set gcc /usr/bin/gcc-4.4 && \
  apt-get autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/* && \
  smbget -a ${URIS}${QUARTUS} -o /quartus-installer/${QUARTUS} && \
  smbget -a ${URIS}${MAX10} -o /quartus-installer/${MAX10} && \
  smbget -a ${URIS}${MODELSIM} -o /quartus-installer/${MODELSIM} && \
  chmod 755 /quartus-installer/${QUARTUS} && \
  chmod 755 /quartus-installer/${MODELSIM} && \
  /quartus-installer/${QUARTUS} --mode unattended --unattendedmodeui none --installdir ${INTELFPGA_TOOLDIR} --accept_eula 1 && \
  /quartus-installer/${MODELSIM} --mode unattended --unattendedmodeui none --installdir ${INTELFPGA_TOOLDIR} --accept_eula 1 && \
  sudo rm -rf /quartus-installer/ && \
     sudo ln -s ${MODELSIM_DIR}/linux ${MODELSIM_DIR}/linux_rh60 && \
     sudo mkdir ${MODELSIM_DIR}/Unused && \
     sudo mv ${MODELSIM_DIR}/gcc-4.* ${MODELSIM_DIR}/Unused

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash", "-c", "source ${INTELFPGA_TOOLDIR}/hls/init_hls.sh;/bin/bash"]

