echo 'Packaging and adding Tomcat base box to local Vagrant installation'
vagrant package --base tomcat-util --output tomcat-util.box
vagrant box add tomcat-util tomcat-util.box
