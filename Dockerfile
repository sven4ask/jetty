FROM askcs/java:openjdk-7-jre
MAINTAINER Sven Stam <sven.stam@gmail.com>

# Install packages
RUN apt-get update && \ 
    apt-get update --fix-missing && \ 
    apt-get install -y wget

# Download and install jetty
ENV JETTY_VERSION 9.2.7
ENV RELEASE_DATE v20150116
RUN wget http://download.eclipse.org/jetty/${JETTY_VERSION}.${RELEASE_DATE}/dist/jetty-distribution-${JETTY_VERSION}.${RELEASE_DATE}.tar.gz && \
    tar -xzvf jetty-distribution-${JETTY_VERSION}.${RELEASE_DATE}.tar.gz && \
    rm -rf jetty-distribution-${JETTY_VERSION}.${RELEASE_DATE}.tar.gz && \
    mv jetty-distribution-${JETTY_VERSION}.${RELEASE_DATE}/ /opt/jetty

# Configure Jetty user and clean up install
RUN useradd jetty && \
    chown -R jetty:jetty /opt/jetty 
    rm -rf /opt/jetty/webapps.demo

RUN cp /opt/jetty/bin/jetty.sh /etc/init.d/jetty

RUN echo "NO_START=0 # Start on boot\nJETTY_HOST=0.0.0.0 # Listen to all hosts\nJETTY_ARGS=jetty.port=8080\nJETTY_USER=jetty # Run as this user\n JETTY_HOME=/opt/jetty" >> /etc/default/jetty
