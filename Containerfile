FROM quay.io/toolbx-images/centos-toolbox:stream8

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="jorge.castro@gmail.com>"

COPY extra-packages /
RUN dnf -y config-manager --add-repo https://download.opensuse.org/repositories/network:messaging:zeromq:release-draft/CentOS_8/network:messaging:zeromq:release-draft.repo && \
    dnf -y config-manager --set-enabled epel-testing && \
    dnf -y install $(<extra-packages)
RUN rm /extra-packages

#RUN   ln -fs /bin/sh /usr/bin/sh && \
#RUN   ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
#      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \
#      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
#      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
#      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update
