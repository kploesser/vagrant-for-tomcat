# TODO Decide whether this should use Ubuntu or RHEL and then select an appropriate LTS release (AWS)
# TODO How do I set up a debugging port in Tomcat and guest VM?

# Installing Oracle Java JDK 8
sudo apt-get update
sudo apt-get install -y python-software-properties debconf-utils
sudo add-apt-repository -y ppa:webupd8team/java && sudo apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer

# sudo apt install oracle-java8-set-default

# Add Tomcat user
sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

# Download Tomcat
cd /home/vagrant
sudo apt-get -y install curl
curl -O --progress-bar http://mirror.ventraip.net.au/apache/tomcat/tomcat-9/v9.0.0.M21/bin/apache-tomcat-9.0.0.M21.tar.gz

# Extract into target directory
sudo mkdir /opt/tomcat
sudo tar xzvf apache-tomcat-9*tar.gz -C /opt/tomcat --strip-components=1

# Assign ownership over target directory
cd /opt/tomcat
sudo chgrp -R tomcat /opt/tomcat
sudo chmod -R g+r conf
sudo chmod g+x conf
sudo chown -R tomcat webapps/ work/ temp/ logs/

# Copy basic Tomcat configuration files
cd /home/vagrant
sudo cp config/context.xml /opt/tomcat/webapps/manager/META-INF/context.xml
sudo cp config/context.xml /opt/tomcat/webapps/host-manager/META-INF/context.xml
sudo cp config/tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml

# Copy service file and reload daemon
sudo cp config/tomcat.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo ufw allow 8080
sudo systemctl enable tomcat

# sudo systemctl status tomcat
# sudo sed -i -e 's=<Valve=<!--<Valve=g' /opt/tomcat/webapps/manager/META-INF/context.xml
# sudo sed -i -e 's=</Context>=--></Context>=g' /opt/tomcat/webapps/manager/META-INF/context.xml
# sudo sed -i -e 's=<Valve=<!--<Valve=g' /opt/tomcat/webapps/host-manager/META-INF/context.xml
# sudo sed -i -e 's=</Context>=--></Context>=g' /opt/tomcat/webapps/host-manager/META-INF/context.xml
# sudo update-java-alternatives -l
