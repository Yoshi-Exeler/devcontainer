FROM centos:latest
RUN dnf install -y git make nano wget unzip
RUN mkdir /root/sdk
RUN wget https://dl.google.com/go/go1.17.1.linux-amd64.tar.gz && tar -C /root/sdk/ -xzf go1.17.1.linux-amd64.tar.gz && rm -rf go1.17.linux-amd64.tar.gz
RUN echo 'export PATH=$PATH:/root/sdk/go/bin' &>> ~/.bashrc && echo 'export PATH=$PATH:/root/sdk/go-path/bin' &>> ~/.bashrc && echo 'export GOROOT=/root/sdk/go' &>> ~/.bashrc && echo 'export GOPATH=/root/sdk/go-path' &>> ~/.bashrc
RUN export GOPATH=/root/sdk/go-path && /root/sdk/go/bin/go get -u golang.org/x/tools/...
RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash - && yum install -y nodejs
RUN npm install --global npm
RUN npm install -g @angular/cli
RUN npm install -g @ionic/cli
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.18.0/protoc-3.18.0-linux-x86_64.zip && unzip protoc-3.18.0-linux-x86_64.zip -d /root/sdk/proto && rm protoc-3.18.0-linux-x86_64.zip
RUN echo 'export PATH=$PATH:/root/sdk/proto/bin' &>> ~/.bashrc
RUN export GOPATH=/root/sdk/go-path && /root/sdk/go/bin/go install github.com/golang/protobuf/protoc-gen-go@latest && /root/sdk/go/bin/go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
RUN npm install -g ts-protoc-gen
WORKDIR /root/data
ENTRYPOINT .container/autoexec.sh && tail -f /dev/null