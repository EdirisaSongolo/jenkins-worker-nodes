FROM ubuntu:24.04

RUN apt-get update
RUN apt-get install -y ca-certificates curl gnupg
RUN apt-get install -qy git
RUN apt-get install -qy openssh-server && \
    sed -i 's|session required pam_loginuid.so|session optional pam_loginud.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd
RUN apt-get install -qy openjdk-17-jdk openjdk-17-jre
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io
RUN curl -L "https://github.com/docker/compose/releases/download/2.30.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose
RUN apt-get -qy autoremove
RUN adduser --quiet ubuntu && \
    echo "ubuntu:password" | chpasswd

COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys

RUN chown -R ubuntu:ubuntu /home/jenkins/.ssh/

EXPOSE 22
VOLUME ["/var/run/docker.sock"]
CMD ["/usr/sbin/sshd", "-D"]