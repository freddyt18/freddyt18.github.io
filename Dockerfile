FROM ubuntu:latest

# Update and install packages
RUN apt-get update && apt-get install -y \
    sudo \
    python3 \
    python3-pip \
    openssh-server \
    git \
    build-essential \
    curl

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

# Add a new user with sudo privileges
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Configure sshd
RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\\s*required\\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]