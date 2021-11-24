FROM archlinux:base-devel
RUN useradd -m -g wheel -s /usr/bin/zsh -d /root -u 1001 yoshi
RUN echo "%wheel ALL=(ALL) ALL" &>> /etc/sudoers 
RUN chown yoshi /
RUN pacman -Syu zsh nodejs-lts-gallium npm unzip openssh --noconfirm
RUN mkdir /root/sdk
COPY ./build/.zshrc /root/.zshrc
RUN curl -LO https://dl.google.com/go/go1.17.3.linux-amd64.tar.gz && tar -C /root/sdk/ -xzf go1.17.3.linux-amd64.tar.gz && rm -rf go1.17.3.linux-amd64.tar.gz
RUN echo 'export PATH=$PATH:/root/sdk/go/bin' &>> ~/.zshrc && echo 'export PATH=$PATH:/root/sdk/go-path/bin' &>> ~/.zshrc && echo 'export GOROOT=/root/sdk/go' &>> ~/.zshrc && echo 'export GOPATH=/root/sdk/go-path' &>> ~/.zshrc
RUN export GOPATH=/root/sdk/go-path && /root/sdk/go/bin/go install golang.org/x/tools/...@latest
RUN export GOPATH=/root/sdk/go-path && /root/sdk/go/bin/go install github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest && /root/sdk/go/bin/go install github.com/ramya-rao-a/go-outline@latest && /root/sdk/go/bin/go install github.com/cweill/gotests/gotests@latest && /root/sdk/go/bin/go install github.com/fatih/gomodifytags@latest && /root/sdk/go/bin/go install github.com/josharian/impl@latest && /root/sdk/go/bin/go install github.com/haya14busa/goplay/cmd/goplay@latest && /root/sdk/go/bin/go install github.com/go-delve/delve/cmd/dlv@latest && /root/sdk/go/bin/go install github.com/go-delve/delve/cmd/dlv@master && /root/sdk/go/bin/go install honnef.co/go/tools/cmd/staticcheck@latest && /root/sdk/go/bin/go install golang.org/x/tools/gopls@latest && /root/sdk/go/bin/go install github.com/rogpeppe/godef@latest
RUN npm install -g @angular/cli
RUN npm install -g @ionic/cli
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.18.0/protoc-3.18.0-linux-x86_64.zip && unzip protoc-3.18.0-linux-x86_64.zip -d /root/sdk/proto && rm protoc-3.18.0-linux-x86_64.zip
RUN echo 'export PATH=$PATH:/root/sdk/proto/bin' &>> ~/.zshrc
RUN export GOPATH=/root/sdk/go-path && /root/sdk/go/bin/go install github.com/golang/protobuf/protoc-gen-go@latest && /root/sdk/go/bin/go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
RUN npm install -g ts-protoc-gen
RUN chown yoshi /root && chown -R yoshi /root/.cache && chown -R yoshi /root/sdk && chown -R yoshi /root/.npm && chown -R yoshi /root/.zshrc
WORKDIR /root/
ENTRYPOINT /usr/bin/sshd -D
