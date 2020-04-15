FROM steamcmd/steamcmd:ubuntu

ENV DBUS_FATAL_WARNINGS=0
RUN apt-get update && \
    apt-get -y install software-properties-common curl && \
    curl -L https://dl.winehq.org/wine-builds/winehq.key | apt-key add - && \
    curl -L https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/Release.key | apt-key add - && \
    apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' && \
    apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./' && \
    apt-get install winehq-stable --no-install-recommends -y && \
    curl -o /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x /usr/bin/winetricks && \
    winetricks -q dotnet48 && \
    steamcmd +login anonymous +force_install_dir /root/.wine/drive_c/users/root/SpaceEngeineersDedicatedServer +app_update 298740 +quit && \
    mkdir -p /data /data/config /data/world && \
    mkdir -p .wine/drive_c/users/root/Application\ Data/SpaceEngineersDedicated

WORKDIR "/root/.wine/drive_c/users/root/SpaceEngeineersDedicatedServer/DedicatedServer64/"
ENTRYPOINT = ["wine", "SpaceEngineersDedicated.exe", "-console"]
