FROM centos:latest
RUN dnf install -y git make nano
WORKDIR /root/data
ENTRYPOINT .container/autoexec.sh && tail -f /dev/null