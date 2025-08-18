### ==== Base Image ====
FROM jenkins/agent:jdk17

LABEL image="jenkins/inbound-agent:latest-jdk17" distro="debian" version="0.2.2-secured"

### ==== Configuración Inicial ====
USER root

RUN echo $PATH

### ==== Verificar Java ====
RUN java -version

WORKDIR /scan
RUN useradd -m -d /home/luser -s /bin/bash luser

USER luser
WORKDIR /home/luser
ENV PATH="/opt/venv/bin:$PATH"

USER jenkins