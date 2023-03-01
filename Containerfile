FROM quay.io/toolbx-images/archlinux-toolbox:latest

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="jorge.castro@gmail.com>"


COPY extra-packages /
RUN pacman -Syu --needed --noconfirm - < extra-packages
RUN rm /extra-packages
RUN pacman -Scc --noconfirm


# === uhhh ===
#RUN   ln -fs /bin/sh /usr/bin/sh && \

# === symlinks for distrobox ===
RUN   ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update


# === install yay package manager for AUR ===
RUN git clone https://aur.archlinux.org/yay.git \
    && cd yay \
    && makepkg -sri --needed --noconfirm \
    && cd \
    # Clean up
    && rm -rf .cache yay
# Clean up cache


# === if and when i switch to arch:base-devel ===
# Enable sudo permission for wheel users
# RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/toolbox

# === sudo instead of wheel if i switch to non-fedora host ===
#ARG user=makepkg
#RUN useradd --system --create-home $user \
#  && echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
#USER $user
#WORKDIR /home/$user

# ================================================================
#  A Dockerfile to install emacs and the latest doom. Expects user to mount over ~/.doom.d/ with a
# https://gist.github.com/eccentric-j/9f57625888c2492dbe53f164076a3695
#FROM phusion/baseimage:18.04-1.0.0
#
#RUN add-apt-repository ppa:kelleyk/emacs \
#    && apt update \
#    && apt install -y git emacs27 tmux vim sqlite3 wget
#
#RUN git clone https://github.com/hlissner/doom-emacs.git ~/.emacs.d
## Might be needed if you want to pre-build the config but not required
## In which case run doom sync via shell
## COPY ./doom.d /root/.doom.d
#RUN yes | ~/.emacs.d/bin/doom install
#VOLUME /root/.doom.d
#WORKDIR /root
#
#CMD ["/usr/bin/emacs", "--daemon"]
