FROM maven:3.5.0-jdk-8 AS builder-atlas

ENV		REPO            https://git-wip-us.apache.org/repos/asf/atlas.git
ENV     BRANCH          branch-0.8
ENV		MAVEN_OPTS		"-Xmx1536m -XX:MaxPermSize=512m"

RUN git clone --branch ${BRANCH} ${REPO} atlas \
	&& cd atlas \
	&& mvn clean package -Pdist,!external-hbase-solr,embedded-hbase-solr -DskipTests \
	&& mv distro/target/apache-atlas-*-bin.tar.gz /apache-atlas.tar.gz

FROM openjdk:8-jdk-alpine

ENV		ATLAS_HOME		/opt/atlas

COPY --from=builder-atlas /apache-atlas.tar.gz /apache-atlas.tar.gz

ADD scripts/start_atlas.sh /usr/bin/start_atlas.sh

RUN apk --no-cache add tar python bash supervisor \
	&& mkdir -p ${ATLAS_HOME} \
	&& mkdir -p /var/lib/atlas \
	&& tar xvz -C ${ATLAS_HOME} -f /apache-atlas.tar.gz --strip-component=1 \
	&& rm -rf /apache-atlas.tar.gz \
	&& mkdir -p ${ATLAS_HOME}/libext \
	&& mv /opt/atlas/conf/hbase/hbase-site.xml.template /opt/atlas/conf/hbase/hbase-site.xml

COPY data/je-7.5.11.tar.gz /tmp

RUN cd /tmp \
	&& tar xvzf je-7.5.11.tar.gz \
	&& mv je-7.5.11/lib/* ${ATLAS_HOME}/libext/ \
	&& rm -rf je-7.5.11*

ADD http://archive.apache.org/dist/zookeeper/zookeeper-3.4.9/zookeeper-3.4.9.tar.gz /tmp

RUN cd /tmp  \
	&& tar xvfz zookeeper-3.4.9.tar.gz \
	&& mkdir -p ${ATLAS_HOME}/zk \
	&& mv zookeeper-3.4.9/* ${ATLAS_HOME}/zk \
	&& mv ${ATLAS_HOME}/zk/conf/zoo_sample.cfg ${ATLAS_HOME}/zk/conf/zoo.cfg \
	&& rm -rf zookeeper*

ADD supervisor/*.ini /etc/supervisor.d/
ADD conf/atlas-application.properties /opt/atlas/conf/

EXPOSE 21000

CMD ["supervisord", "-n"]