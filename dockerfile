FROM drjp81/powershell
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true
ARG TARGETPLATFORM
ARG TARGETARCH
ARG BUILDPLATFORM
ARG TARGETOS
SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue'; $verbosePreference='Continue';"]
RUN mkdir /work
WORKDIR /work
COPY ./getradarr.ps1 /work/getradarr.ps1
RUN (gci /work -file).Fullname \
&& /usr/bin/pwsh -file /work/getradarr.ps1
RUN apt-get update \ 
&& apt-get install ffmpeg mediainfo sqlite3 -y --no-install-recommends \
&& tar -xvf ./Radarr.Binaries.tar.gz \
&& mv ./Radarr/ /opt/  \
&& rm -rf ./Radarr.Binaries.tar.gz \
&& apt-get clean
EXPOSE 7878
ENTRYPOINT ["/opt/Radarr/Radarr", "-nobrowser" , "-data=/usr/local/radarr"] 
