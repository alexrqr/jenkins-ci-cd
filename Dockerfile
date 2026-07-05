## CONSTRUCCIÓN DE DOCKER PARA DESCARGAR JENKINS-MAVEN Y DEMAS RECURSOS... CI-CD
# Imagen base de Jenkins LTS
FROM jenkins/jenkins:lts

# Trabajar como root para instalar dependencias
USER root

# Instalar dependencias básicas
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        gnupg \
        lsb-release \
        maven && \
    rm -rf /var/lib/apt/lists/*

# Agregar el repositorio oficial de Docker
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
    > /etc/apt/sources.list.d/docker.list

# Instalar únicamente el cliente de Docker y sus plugins
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        docker-ce-cli \
        docker-buildx-plugin \
        docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*

# Verificar instalaciones
RUN java -version && \
    mvn -version && \
    docker --version

# Crear el grupo docker (si no existe) y agregar el usuario jenkins
RUN groupadd -f docker && \
    usermod -aG docker jenkins

# Volver al usuario de Jenkins
USER jenkins