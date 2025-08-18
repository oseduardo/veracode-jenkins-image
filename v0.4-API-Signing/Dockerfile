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

### ==== Veracode API Signing ====
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

WORKDIR /scan
RUN useradd -m -d /home/luser -s /bin/bash luser

USER luser
WORKDIR /home/luser
ENV PATH="/opt/venv/bin:$PATH"

USER jenkins