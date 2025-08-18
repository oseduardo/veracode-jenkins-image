### ==== Base Image ====
FROM jenkins/agent:jdk17

LABEL image="jenkins/inbound-agent:latest-jdk17" distro="debian" version="0.2.2-secured"

### ==== Configuración Inicial ====
USER root

# Update and install all packages in a single layer to reduce image size
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        curl \
        gnupg \
        unzip \
        git \
        git-lfs \
        perl \
        openssl \
        xz-utils \
        libfreetype6 \
        gnutls-bin \
        zip \
        bash \
        gradle \
        maven  && \
    # Remove vulnerable packages
    apt-get purge -y \
        libbcel-java \
        libjgit-java && \
    rm -rf /usr/share/java/{bcel,jgit}* && \
    # Attempt sqlite3 upgrade (with fallback)
    (apt-get purge -y libsqlite3-0 && \
     apt-get install -y --no-install-recommends libsqlite3-0=3.40.1-2+deb12u2 || \
     echo "Warning: Could not install updated sqlite3 package, proceeding anyway") && \
    # Clean up
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo $PATH

### ==== Verificar Java ====
RUN java -version

### ==== Veracode Pipeline Scan (Versión Segura) ====
ENV VERACODE_DIR=/opt/veracode \
    PIPELINE_SCAN_JAR=/opt/veracode/pipeline-scan.jar \
    PIPELINE_SCAN_URL="https://downloads.veracode.com/securityscan/pipeline-scan-LATEST.zip"

RUN mkdir -p ${VERACODE_DIR} && \
    useradd -m veracode && \
    curl -sSL ${PIPELINE_SCAN_URL} -o /tmp/pipeline-scan.zip && \
    unzip -p /tmp/pipeline-scan.zip pipeline-scan.jar > ${PIPELINE_SCAN_JAR} && \
    rm /tmp/pipeline-scan.zip && \
    chmod 755 ${PIPELINE_SCAN_JAR}

### ==== Veracode API Wrapper ====
ENV VERSION="24.10.15.0" \
    ARTIFACT_NAME="vosp-api-wrappers-java" \
    INSTALL_DIR="/opt/veracode"

RUN mkdir -p ${INSTALL_DIR} && \
    curl -L -o /tmp/wrapper.zip \
    "https://repo1.maven.org/maven2/com/veracode/vosp/api/wrappers/${ARTIFACT_NAME}/${VERSION}/${ARTIFACT_NAME}-${VERSION}-dist.zip" && \
    unzip /tmp/wrapper.zip -d ${INSTALL_DIR} && \
    rm /tmp/wrapper.zip


WORKDIR /scan
RUN useradd -m -d /home/luser -s /bin/bash luser

USER luser
WORKDIR /home/luser
ENV PATH="/opt/venv/bin:$PATH"

USER jenkins