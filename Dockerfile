FROM centos:latest
RUN dnf install -y git make nano wget
RUN mkdir /root/sdk
RUN wget https://dl.google.com/go/go1.17.1.linux-amd64.tar.gz && tar -C /root/sdk/ -xzf go1.17.1.linux-amd64.tar.gz && rm -rf go1.17.linux-amd64.tar.gz
RUN echo "export PATH=$PATH:/root/sdk/go/bin" &>> ~/.bashrc && echo "export GOROOT=/root/sdk/go" &>> ~/.bashrc && echo "export GOPATH=/root/data/workspace" &>> ~/.bashrc
RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash - && yum install -y nodejs
RUN npm install --global npm
RUN npm install -g @angular/cli
RUN npm install -g @ionic/cli
WORKDIR /root/data
ENTRYPOINT .container/autoexec.sh && tail -f /dev/null