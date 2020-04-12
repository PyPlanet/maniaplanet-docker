FROM alpine:3.11.5
LABEL maintainer="Tom Valk <tomvalk@lt-box.info>"
ENV DEDICATED_URL http://files.v04.maniaplanet.com/server/ManiaplanetServer_2019-10-23.zip
ENV PROJECT_ROOT /app/dedicated
ENV TEMPLATE_DIR /app/dedicated-configs

# Create maniaplanet user/group
RUN addgroup -g 1000 maniaplanet && \
    adduser -u 1000 -D -G maniaplanet maniaplanet

# Link the musl to glibc as it's compatible (required in Alpine image).
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
 && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.31-r0/glibc-2.31-r0.apk \
 && apk add glibc-2.31-r0.apk libstdc++ musl libuuid wget

ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/:/lib/"

# Create project root.
RUN mkdir -p $PROJECT_ROOT 
RUN mkdir -p $TEMPLATE_DIR
WORKDIR $PROJECT_ROOT

# Download dedicated.
RUN wget $DEDICATED_URL -qO /tmp/dedicated.zip

RUN unzip -q /tmp/dedicated.zip -d ./ \
    && rm /tmp/dedicated.zip \
    && rm -rf ./*.bat ./*.exe ./*.html ./RemoteControlExamples \ 
    && chmod +x ./ManiaPlanetServer \
    && mkdir -p ./GameData \
    && mkdir -p ./UserData \
    && mkdir -p ./UserData/Config \
    && mkdir -p ./UserData/Packs \
    && mkdir -p ./UserData/Maps \
    && mkdir -p ./UserData/Maps/MatchSettings

# Install the dedicated configuration file(s).
COPY config.default.xml $TEMPLATE_DIR/config.txt
COPY matchsettings.default.xml $TEMPLATE_DIR/matchsettings.txt
COPY stadium_map.Map.gbx $TEMPLATE_DIR/stadium_map.Map.gbx

# Install run script.
COPY entrypoint.sh ./start.sh
RUN chmod +x ./start.sh
RUN chown -R maniaplanet:maniaplanet $PROJECT_ROOT
RUN chown -R maniaplanet:maniaplanet $TEMPLATE_DIR

USER maniaplanet

# Expose ports.
EXPOSE 2350 2350/udp 3450 3450/udp 5000

CMD [ "./start.sh" ]
