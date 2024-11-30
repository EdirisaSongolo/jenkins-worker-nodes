FROM ubuntu:24.04

RUN apt-get install -y sudo
RUN sudo -i
RUN sudo apt-get update
RUN sudo apt-get install -y ca-certificates curl gnupg
RUN sudo apt-get install -qy git
RUN sudo apt-get install -qy openssh-server && \
    sed -i 's|session required pam_loginuid.so|session optional pam_loginud.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd
RUN sudo apt-get install -qy openjdk-17-jdk openjdk-17-jre
RUN sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN sudo echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN sudo apt-get update
RUN sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose
RUN sudo systemctl enable docker && systemctl start docker
RUN sudo apt-get -qy autoremove
RUN sudo adduser --quiet jenkins && \
    echo "jenkins:password" | chpasswd && \
    mkdir /home/jenkins/.m2

COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys

RUN chown -R jenkins:jenkins /home/jenkins/.m2/ && \
    chown -R jenkins:jenkins /home/jenkins/.ssh/

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]