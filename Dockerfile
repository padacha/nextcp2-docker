FROM ubuntu:jammy

WORKDIR /app

# Install dependencies
RUN apt-get -y update && apt-get -y install git vim openssh-server openjdk-17-jdk yarn
RUN sed -i 's/# PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config && sed -i 's/^# Port/^Port/' /etc/ssh/sshd_config
RUN wget https://github.com/sf666/nextcp2/releases/download/v2.6.1/device_driver_ma9000.jar && wget https://github.com/sf666/nextcp2/releases/download/v2.6.1/nextcp2.jar
RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz && tar -xzvf apache-maven-3.9.6-bin.tar.gz && mv apache-maven-3.9.6 /usr/local/bin/
RUN git clone https://github.com/sf666/nextcp2.git
RUN /bin/bash /app/nextcp2/build_dependencies.sh

VOLUME /app
# timezone settings
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN useradd -rm -d /home/nextcp2 -s /bin/bash -g root -G sudo -u 1001 app

EXPOSE 8085
ENTRYPOINT ["java", "-Xms256m", "-Xmx512m", "-DconfigFile=/app/nextcp2config.json", "-jar", "/app/nextcp2.jar"]

