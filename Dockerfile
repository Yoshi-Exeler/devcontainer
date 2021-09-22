FROM centos:latest
RUN dnf install -y git make nano
ENTRYPOINT tail -f /dev/null