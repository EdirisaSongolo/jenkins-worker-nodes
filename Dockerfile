FROM ubuntu:24.04

RUN apt-get update
RUN apt-get install -y ca-certificates curl gnupg
RUN apt-get install -qy git
RUN apt-get install -qy openssh-server && \
    sed -i 's|session required pam_loginuid.so|session optional pam_loginud.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd
RUN apt-get install -qy openjdk-17-jdk openjdk-17-jre
RUN apt-get -qy autoremove
RUN adduser --quiet jenkins && \
    echo "jenkins:password" | chpasswd && \
    mkdir /home/jenkins/.m2

COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys

RUN chown -R jenkins:jenkins /home/jenkins/.m2/ && \
    chown -R jenkins:jenkins /home/jenkins/.ssh/

EXPOSE 22

VOLUME ["/var/run/docker.sock"]

CMD ["/usr/sbin/sshd", "-D"]