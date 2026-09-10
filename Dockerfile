FROM ubuntu:24.04

# Evita que apt pida confirmaciones interactivas durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualiza e instala las herramientas esenciales de desarrollo, ensambladores y depuradores
RUN apt-get update && apt-get install -y \
    build-essential \
    nasm \
    gdb \
    git \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Directorio de trabajo dentro del contenedor
WORKDIR /workspace

CMD ["/bin/bash"]