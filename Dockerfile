FROM centos:7
MAINTAINER James Hebden <jhebden@hebden.net.au>

# install adobe repo and winswitch repo
RUN yum -y install curl
RUN cd /etc/yum.repos.d/ && curl -O https://winswitch.org/downloads/CentOS/winswitch.repo
RUN rpm -ivh http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -ivh http://awel.domblogger.net/7/media/x86_64/awel-media-release-7-6.noarch.rpm
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux

# xpra, firefox, alsa, flash
RUN yum -y update
RUN yum -y install gcc python-devel libXtst-devel libXdamage-devel \
    gtk2-devel pygtk2-devel pygobject2-devel libxkbfile-devel \
    redhat-rpm-config xorg-x11-server-Xorg xorg-x11-drv-dummy xorg-x11-xauth \
    libvpx-xpra xorg-x11-xkb-utils xpra python-websockify gstreamer-python \
    xorg-x11-fonts-Type1 xorg-x11-fonts-75dpi dejavu-sans-fonts urw-fonts \
    gstreamer1 gstreamer1-plugins-good gstreamer1-plugins-bad \
    pulseaudio pulseaudio-utils gstreamer-tool alsa-utils python-gobject \
    flash-plugin nspluginwrapper alsa-plugins-pulseaudio libcurl firefox

# expose port 
EXPOSE 8080

# Create a dedicated user, mapped to UID/GID 1000
RUN groupmod xpra -g 1000
RUN useradd xpra --password '*' --create-home -u 1000 -g 1000
RUN mkdir /var/run/xpra
RUN chown -R xpra:xpra /var/run/xpra
RUN mkdir -p /run/1000/xpra
RUN chown -R xpra:xpra /run/1000

USER xpra
ENV HOME /home/xpra

# run xpra with firefox
CMD ["xpra", "start", ":0", "--start=firefox", "--dpi=96",  "--daemon=off", "--bind-tcp=0.0.0.0:8080", "--html=on", "--clipboard=to-server", "--no-pulseaudio", "--speaker=on"]
