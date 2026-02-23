#!/bin/bash
TODAY=$(date "+%d_%m_%Y")
JDK_VERSION=jdk-8u131-linux-x64
JBSS_VERSION=jboss-as-7.1.1.Final
sudo su -
cd /

# == JDK ==
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/$JDK_VERSION.tar.gz
gunzip $JDK_VERSION.tar.gz
tar -xf $JDK_VERSION.tar
rm -f $JDK_VERSION.tar
mv jdk1.8.0_131 jdk-8
ln -s /opt/jdk-8/bin/java /usr/bin

# == JBoss ==
mkdir /opt/jboss
cd /opt/jboss
groupadd jboss
useradd -m -s /bin/bash -g jboss jboss
wget https://download.jboss.org/jbossas/7.1/$JBSS_VERSION/$JBSS_VERSION.zip
unzip $JBSS_VERSION.zip
rm -rf $JBSS_VERSION.zip
cp $JBSS_VERSION/standalone/configuration/standalone.xml $JBSS_VERSION/standalone/configuration/standalone_$TODAY.xml
cd $JBSS_VERSION/standalone/configuration/
sed -i '289 a \\t\<interface name="external">' standalone.xml
sed -i '290 a \\t\ \t\<nic name="enX0"\/>' standalone.xml
sed -i '291 a \\t\<\/interface>' standalone.xml
sed -i '296 s/management/external/2' standalone.xml
sed -i '297 s/management/external/2' standalone.xml
sed -i '298 s/"ajp"/"ajp" interface="external"/' standalone.xml
sed -i '299 s/"http"/"http" interface="external"/' standalone.xml
sed -i '300 s/"https"/"https" interface="external"/' standalone.xml
cd /opt/jboss/$JBSS_VERSION/bin
# in /bin/standalone.sh you can change memory
# in standalone.conf you can change JAVA_HOME
# ./standalone.sh -b 0.0.0.0 -Dpath_commons=/opt/jboss/7.1/extra_properties
./standalone.sh -b 0.0.0.0
