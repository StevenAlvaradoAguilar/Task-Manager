# syntax = docker/dockerfile:1

# Usa la imagen oficial de PostgreSQL como base
FROM postgres:latest

# Variables de entorno para configurar el usuario, contraseña y base de datos
ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENV POSTGRES_DB=${POSTGRES_DB}

# Copia los scripts de inicialización a la ubicación predeterminada de PostgreSQL
# para que se ejecuten cuando se inicie el contenedor
COPY init.sql /docker-entrypoint-initdb.d/
