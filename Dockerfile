FROM steamcmd/steamcmd:ubuntu

# work-around due to wine issue
ENV DBUS_FATAL_WARNINGS=0
ENV UPDATE=false
ARG app_user=steam

RUN apt-get update && \
    apt-get -y install software-properties-common curl && \
    curl -L https://dl.winehq.org/wine-builds/winehq.key | apt-key add - && \
    curl -L https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/Release.key | apt-key add - && \
    apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' && \
    apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./' && \
    apt-get install winehq-stable --no-install-recommends -y && \
    curl -o /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x /usr/bin/winetricks && \
    useradd -m -d /home/$app_user $app_user && \
    mkdir -p /data /data/config /data/world && \
    chown -R $app_user /data
    

USER $app_user
WORKDIR /home/$app_user
ENV HOME=/home/$app_user
ENV USER=$app_user

RUN wineboot -u && \
    winetricks -q dotnet48

RUN steamcmd +login anonymous +force_install_dir $HOME/.wine/drive_c/users/$app_user/SpaceEngeineersDedicatedServer +app_update 298740 +quit && \
    mkdir -p $HOME/.wine/drive_c/users/$app_user/Application\ Data/SpaceEngineersDedicated && \
    ln -s /data/config/SpaceEngineers-Dedicated.cfg $HOME/.wine/drive_c/users/$app_user/Application\ Data/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg 

EXPOSE 27016/udp
VOLUME ["/data/config", "/data/world"]
ADD start-spceng-server /usr/bin/start-spceng-server
ENTRYPOINT ["/usr/bin/start-spceng-server"]
CMD ["-console"]
