FROM debian:latest

RUN apt update && apt upgrade -y
RUN apt install -y curl sudo man

RUN useradd -m quitlox
RUN adduser quitlox sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER quitlox
ADD ./scripts/setup/bootstrap.sh /home/quitlox/
WORKDIR /home/quitlox/

