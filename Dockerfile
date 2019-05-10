FROM ubuntu16
LABEL maintainer "ittou <VYG07066@gmail.com>"
ENV DEBIAN_FRONTEND noninteractive

ARG QUARTUS=QuartusLiteSetup-18.1.0.625-linux.run
ARG MAX10=max10-18.1.0.625.qdz
ARG MODELSIM=ModelSimSetup-18.1.0.625-linux.run

COPY $QUARTUS /$QUARTUS
COPY $MAX10 /$MAX10
COPY $MODELSIM /$MODELSIM

RUN apt-get update && \
    apt-get -y -qq install apt-utils sudo && \
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
    chmod 755 /$QUARTUS
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y -qq install libc6:i386 \
                           libncurses5:i386 \
                           libstdc++6:i386 \
                           libxft2:i386 \
                           libxext6:i386


RUN    /$QUARTUS --mode unattended --unattendedmodeui none --installdir /opt/Intel/intelFPGA_lite/18.1 --accept_eula 1 && \
       /$MODELSIM --mode unattended --unattendedmodeui none --installdir /opt/Intel/intelFPGA_lite/18.1 --accept_eula 1 && \
    sudo rm -f /$QUARTUS && \
    sudo rm -f /$MODELSIM && \
    sudo rm -f /$MAX10

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash", "-l"]

