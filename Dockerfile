# pull archlinux + base developement programs like make and gcc
FROM archlinux:base-devel 
# copy zshrc into the container
ADD ./build/.zshrc /root/.zshrc
# setup a user with the correct name and uid, set permissions for the user, create sdk folder
RUN useradd -m -g wheel -s /usr/bin/zsh -d /root -u 1001 yoshi && \
    echo "%wheel ALL=(ALL) ALL" &>> /etc/sudoers && \
    chown yoshi / && \
    chown -R yoshi /root/.zshrc && \
    mkdir /root/sdk && \
    chown -R yoshi /root/sdk
# install all additional packages that we can get from pacman
RUN pacman -Syu zsh nodejs-lts-gallium git npm unzip openssh --noconfirm
# install npm packages
RUN npm install -g @angular/cli && \
    npm install -g @ionic/cli && \
    npm install -g ts-protoc-gen
# install pinned golang version to our sdk dir. We could use pacman for this but i wanted a custom install dir.
RUN curl -LO https://dl.google.com/go/go1.17.3.linux-amd64.tar.gz && \
    tar -C /root/sdk/ -xzf go1.17.3.linux-amd64.tar.gz && \
    rm -rf go1.17.3.linux-amd64.tar.gz
# install pinned protoc version
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.18.0/protoc-3.18.0-linux-x86_64.zip && \
    unzip protoc-3.18.0-linux-x86_64.zip -d /root/sdk/proto && \
    rm protoc-3.18.0-linux-x86_64.zip
# install golang base x/tools, additional analysis tools and protoc plugins
RUN export GOPATH=/root/sdk/go-path && \
    /root/sdk/go/bin/go install golang.org/x/tools/...@latest && \
    /root/sdk/go/bin/go install github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest && \
    /root/sdk/go/bin/go install github.com/ramya-rao-a/go-outline@latest && \
    /root/sdk/go/bin/go install github.com/cweill/gotests/gotests@latest && \
    /root/sdk/go/bin/go install github.com/fatih/gomodifytags@latest && \
    /root/sdk/go/bin/go install github.com/josharian/impl@latest && \
    /root/sdk/go/bin/go install github.com/haya14busa/goplay/cmd/goplay@latest && \
    /root/sdk/go/bin/go install github.com/go-delve/delve/cmd/dlv@latest && \ 
    /root/sdk/go/bin/go install github.com/go-delve/delve/cmd/dlv@master && \ 
    /root/sdk/go/bin/go install honnef.co/go/tools/cmd/staticcheck@latest && \ 
    /root/sdk/go/bin/go install golang.org/x/tools/gopls@latest && \ 
    /root/sdk/go/bin/go install github.com/rogpeppe/godef@latest && \
    /root/sdk/go/bin/go install github.com/golang/protobuf/protoc-gen-go@latest && \
    /root/sdk/go/bin/go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
# append overrides for host $GOPATH and $GOROOT to .sshzshrc
RUN echo 'export PATH=$PATH:/root/sdk/go/bin' &>> ~/.zshrc && \
    echo 'export PATH=$PATH:/root/sdk/go-path/bin' &>> ~/.zshrc && \
    echo 'export GOROOT=/root/sdk/go' &>> ~/.zshrc && \
    echo 'export GOPATH=/root/sdk/go-path' &>> ~/.zshrc && \
    echo 'export PATH=$PATH:/root/sdk/proto/bin' &>> ~/.zshrc
# set correct ownerships for the created directories
RUN chown yoshi /root && \
    chown -R yoshi /root/.cache && \
    chown -R yoshi /root/.npm
# set container entrypoint to sshd in non deamon mode
ENTRYPOINT /usr/bin/sshd -D
