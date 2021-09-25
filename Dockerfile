FROM centos:latest
RUN dnf install -y git make nano wget unzip
RUN mkdir /root/sdk
RUN wget https://dl.google.com/go/go1.17.1.linux-amd64.tar.gz && tar -C /root/sdk/ -xzf go1.17.1.linux-amd64.tar.gz && rm -rf go1.17.linux-amd64.tar.gz
RUN echo 'export PATH=$PATH:/root/sdk/go/bin' &>> ~/.bashrc && echo 'export PATH=$PATH:/root/sdk/go-path/bin' &>> ~/.bashrc && echo 'export GOROOT=/root/sdk/go' &>> ~/.bashrc && echo 'export GOPATH=/root/sdk/go-path' &>> ~/.bashrc
RUN export GOPATH=/root/sdk/go-path && /root/sdk/go/bin/go install golang.org/x/tools/...@latest
RUN export GOPATH=/root/sdk/go-path && /root/sdk/go/bin/go install github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest && /root/sdk/go/bin/go install github.com/ramya-rao-a/go-outline@latest && /root/sdk/go/bin/go install github.com/cweill/gotests/gotests@latest && /root/sdk/go/bin/go install github.com/fatih/gomodifytags@latest && /root/sdk/go/bin/go install github.com/josharian/impl@latest && /root/sdk/go/bin/go install github.com/haya14busa/goplay/cmd/goplay@latest && /root/sdk/go/bin/go install github.com/go-delve/delve/cmd/dlv@latest && /root/sdk/go/bin/go install github.com/go-delve/delve/cmd/dlv@master && /root/sdk/go/bin/go install honnef.co/go/tools/cmd/staticcheck@latest && /root/sdk/go/bin/go install golang.org/x/tools/gopls@latest && /root/sdk/go/bin/go install github.com/rogpeppe/godef@latest
RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash - && yum install -y nodejs
RUN npm install --global npm
RUN npm install -g @angular/cli
RUN npm install -g @ionic/cli
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.18.0/protoc-3.18.0-linux-x86_64.zip && unzip protoc-3.18.0-linux-x86_64.zip -d /root/sdk/proto && rm protoc-3.18.0-linux-x86_64.zip
RUN echo 'export PATH=$PATH:/root/sdk/proto/bin' &>> ~/.bashrc
RUN export GOPATH=/root/sdk/go-path && /root/sdk/go/bin/go install github.com/golang/protobuf/protoc-gen-go@latest && /root/sdk/go/bin/go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
RUN npm install -g ts-protoc-gen
COPY ./personalize.sh /root/personalize.sh
WORKDIR /root/
ENTRYPOINT ./personalize.sh && rm personalize.sh && tail -f /dev/null