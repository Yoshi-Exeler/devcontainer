FROM centos:latest
RUN dnf install -y git make nano wget
RUN mkdir /root/sdk
RUN wget https://dl.google.com/go/go1.17.1.linux-amd64.tar.gz && tar -C /root/sdk/ -xzf go1.17.1.linux-amd64.tar.gz && rm -rf go1.17.linux-amd64.tar.gz
RUN echo "export PATH=$PATH:/root/sdk/go/bin" &>> ~/.bashrc
RUN echo "export GOROOT=/root/sdk/go" &>> ~/.bashrc
RUN echo "export GOPATH=/root/data/workspace" &>> ~/.bashrc
WORKDIR /root/data
ENTRYPOINT .container/autoexec.sh && tail -f /dev/null