FROM centos:latest
RUN yum -y update \
        && yum install -y \
                java-1.8.0-openjdk-devel \
                git \
                wget \
                initscripts \
                vim \
                sshd \
                net-tools \
                docker \
                tcpdump \
                gem \
                e2fsprogs \
                telnet \
                tar \
                maven \
        && yum clean all
CMD ["/sbin/my_init"]
ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
ENV JRE_HOME=/usr/lib/jvm/jre
ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_MINOR_VERSION 8.0.11
ENV CATALINA_HOME /tomcat
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
	wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
	tar zxf apache-tomcat-*.tar.gz && \
 	rm apache-tomcat-*.tar.gz && \
 	mv apache-tomcat* tomcat
ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
RUN mkdir /etc/service
RUN mkdir /etc/service/tomcat
ADD run.sh /etc/service/tomcat/run
RUN chmod +x /*.sh
RUN chmod +x /etc/service/tomcat/run
ADD java-1 /java-1
RUN cd /java-1 && mvn package
RUN cp /java-1/target/CounterWebApp.war /tomcat/webapps
EXPOSE 8080
CMD ["catalina.sh", "run"]

