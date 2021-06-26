FROM debian:stable-slim

LABEL maintainer="mcbplay1@gmail.com"

RUN apt-get update && \
	apt-get -y install --no-install-recommends wget locales procps && \
	touch /etc/locale.gen && \
	echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
	locale-gen && \
	apt-get -y install --reinstall ca-certificates && \
	rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
	apt-get -y install --no-install-recommends xz-utils unzip screen && \
	rm -rf /var/lib/apt/lists/*

RUN wget -O /tmp/gotty.tar.gz https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz && \
	tar -C /usr/bin/ -xvf /tmp/gotty.tar.gz && \
	rm -rf /tmp/gotty.tar.gz

ENV DATA_DIR="/serverdata"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_CONFIG=""
ENV SRV_ADR="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"
ENV MANUAL_UPDATES=""
ENV ENABLE_WEBCONSOLE="true"
ENV GOTTY_PARAMS="-w -c barczuseq:Rockklawmech0123! --title-format RockRP"
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV SERVER_KEY="wmvpuernyr8phixno3afnnahjapalsvu"
ENV START_VARS="+set txAdminPort 40121"
ENV DATA_PERM=770
ENV USER="fivem"

RUN mkdir $DATA_DIR && \
	mkdir $SERVER_DIR && \
	useradd -d $SERVER_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]
