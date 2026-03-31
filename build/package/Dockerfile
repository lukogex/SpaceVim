FROM ubuntu:latest

RUN apt update && \
    apt install -y \
    neovim \
    curl \
    python3-dev \
    python3-pynvim \
    lua5.3 \
    git \
    universal-ctags \
    silversearcher-ag && \
    apt clean

ENV HOME /home/spacevim

RUN groupdel users \
  && groupadd -r spacevim \
  && useradd --create-home --home-dir $HOME -r -g spacevim spacevim

USER spacevim

WORKDIR $HOME

ENV PYTHON3_HOST_PROG "/usr/bin/python3"

RUN mkdir -p $HOME/.config $HOME/.spacevim.d

COPY build/package/init.toml $HOME/.spacevim.d/init.toml
COPY scripts/install_spacevim.sh $HOME/scripts/install_spacevim.sh

RUN $HOME/scripts/install_spacevim.sh

RUN nvim --headless +'call dein#install#_update([], "install", v:false)' +qall

RUN rm $HOME/.spacevim.d/init.toml

ENTRYPOINT nvim
