FROM ubuntu:20.04

# Set up envs
ENV GOROOT="/opt/go"
ENV GORBIN="/opt/go/bin"
ENV PATH=/opt/ses/bin:$PATH
ENV PATH=$PATH:/opt/go/bin
ENV PATH=$PATH:/root/go/bin
ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Create install dir for delete it after install
RUN mkdir install
WORKDIR /root/install

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y build-essential groff less gcc make git unzip python3-pip ruby bzip2 wget curl libfreetype6 libxrender1 libfontconfig1 libusb-1.0-0 \
    && apt-get clean 

# Install deps over pip
RUN pip3 install --upgrade pip --no-cache-dir \
    && pip3 install nrfutil awscli boto3 --no-cache-dir 

# Install deps over gem
RUN gem install ceedling \
    && gem sources -c 

# Install golang and goembehelp
RUN wget https://golang.org/dl/go1.17.3.linux-amd64.tar.gz \ 
    && tar -C /opt -xzf go1.17.3.linux-amd64.tar.gz \
    && go install github.com/borchevkin/goembehelp@latest

# Install Segger Embedded Studio 7.10a
RUN wget https://www.segger.com/downloads/embedded-studio/EmbeddedStudio_ARM_Linux_x64 -O ses_install.tar.gz \
    && tar -xzf ses_install.tar.gz \
    && /bin/sh -c '/bin/echo -e "yes\n" | ./arm_segger_embedded_studio_v710a_linux_x64/install_segger_embedded_studio --copy-files-to /opt/ses'

# Install nRF command-line tools 10.18.1 Linux amd 64
RUN wget https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-command-line-tools/sw/versions-10-x-x/10-18-1/nrf-command-line-tools_10.18.1_amd64.deb \
    && dpkg -i nrf-command-line-tools_10.18.1_amd64.deb

# Clean install files
WORKDIR /root
RUN rm -r -f /root/install/

