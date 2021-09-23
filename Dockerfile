FROM centos:latest
RUN yum install update && yum install upgrade
RUN dnf install -y git make nano wget unzip zsh htop openssh_clients
RUN mkdir /root/sdk
RUN wget https://dl.google.com/go/go1.17.1.linux-amd64.tar.gz && tar -C /root/sdk/ -xzf go1.17.1.linux-amd64.tar.gz && rm -rf go1.17.linux-amd64.tar.gz
RUN echo 'export PATH=$PATH:/root/sdk/go/bin' &>> ~/.zshrc && echo 'export PATH=$PATH:/root/sdk/go-path/bin' &>> ~/.zshrc && echo 'export GOROOT=/root/sdk/go' &>> ~/.zshrc && echo 'export GOPATH=/root/sdk/go-path' &>> ~/.zshrc
RUN export GOPATH=/root/sdk/go-path && /root/sdk/go/bin/go get -u golang.org/x/tools/...
RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash - && yum install -y nodejs
RUN npm install --global npm
RUN npm install -g @angular/cli
RUN npm install -g @ionic/cli
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.18.0/protoc-3.18.0-linux-x86_64.zip && unzip protoc-3.18.0-linux-x86_64.zip -d /root/sdk/proto && rm protoc-3.18.0-linux-x86_64.zip
RUN echo 'export PATH=$PATH:/root/sdk/proto/bin' &>> ~/.zshrc
RUN export GOPATH=/root/sdk/go-path && /root/sdk/go/bin/go install github.com/golang/protobuf/protoc-gen-go@latest && /root/sdk/go/bin/go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
RUN npm install -g ts-protoc-gen
RUN chsh -s /bin/zsh
COPY ./autoexec.sh /root/autoexec.sh
WORKDIR /root/
ENTRYPOINT ./autoexec.sh && rm autoexec.sh && tail -f /dev/null