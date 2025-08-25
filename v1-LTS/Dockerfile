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

### ==== Veracode CLI ====
RUN mkdir -p /app && \
    cd /app && \
    curl -fsS https://tools.veracode.com/veracode-cli/install | sh && \
    find / -name veracode -type f -exec mv {} /usr/local/bin/ \; && \
    chmod +x /usr/local/bin/veracode && \
    rm -rf /app

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


RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.11 \
    python3.11-venv \
    python3-pip && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip==24.0 && \
    /opt/venv/bin/pip install --upgrade setuptools==78.1.1 && \
    /opt/venv/bin/pip install --upgrade urllib3==2.5.0 && \
    /opt/venv/bin/pip install veracode-api-signing


### ==== Veracode API Wrapper ====
ENV VERSION="25.8.16.1" \
    ARTIFACT_NAME="vosp-api-wrappers-java" \
    INSTALL_DIR="/opt/veracode"

RUN mkdir -p ${INSTALL_DIR} && \
    curl -L -o /tmp/wrapper.zip \
    "https://repo1.maven.org/maven2/com/veracode/vosp/api/wrappers/${ARTIFACT_NAME}/${VERSION}/${ARTIFACT_NAME}-${VERSION}-dist.zip" && \
    unzip /tmp/wrapper.zip -d ${INSTALL_DIR} && \
    rm /tmp/wrapper.zip

### ==== validacion.sh y validación de jackson ====
#COPY validacion.sh /usr/local/bin/validacion.sh
#RUN chmod +x /usr/local/bin/validacion.sh && \
#    sed -i 's/\r$//' /usr/local/bin/validacion.sh

WORKDIR /scan
RUN useradd -m -d /home/luser -s /bin/bash luser

USER luser
WORKDIR /home/luser
ENV PATH="/opt/venv/bin:$PATH"
ENTRYPOINT ["/bin/sh"]

USER jenkins