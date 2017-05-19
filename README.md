# Tomcat Utility for Vagrant

## Getting Started

The examples given below are given for Windows 8.1 and Chocolatey.

### Administrator Prompt
Installing software components in the following assumes you are using an administrator prompt (in case you are using Windows). Here’s how to create an administrator prompt:

![Screenshot](https://raw.githubusercontent.com/kploesser/tomcat-util/master/img/img01.png)

### Install Choco (Optional)
You can use choco to install software prerequisites in “silent mode”. In order to do so, simply paste the command below into an administrator prompt and execute it. This step is optional.

If you do not wish to install software in silent mode, download the corresponding installer for each of the software packages listed in the following.

```
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

```

### Install Git
Install Git to check out code, build scripts, data sets, and provisioning scripts as required. We will use Git in the following to check out the provisioning script for our demo VM.

```
choco install git -y

```

### Install VirtualBox

Required to run the guest machine on your host. Install it via the following command.

```
choco install virtualbox -y

```

### Install Vagrant

Required to create, provision, and manage guests. Install it via the following command.

```
choco install vagrant -y

```

### Install Packer (Optional)
Optional component. Used in the later stages of the tutorial to build VMs for deployment.

```
choco install packer -y

```

### Clone VM Template
Before you can run this step, please verify that you have a working Git installation. Then paste the following command into your administrator prompt and execute it.

```
git clone https://github.com/kploesser/tomcat-util.git

```

The command will clone the VM template for provisioning a fully functional Tomcat server as virtual machine (guest) on your workstation (host). The following settings have been applied:

* Guest OS is Ubuntu 16.04 LTS (Xenial)
* Java JDK version is Oracle Java JDK 8
* Tomcat version is 9.0 (M21)
* Port forwarding is set to 4000 on the host machine
* Use http://localhost:4000 to log into the Tomcat web interface after installation

The git command creates the following folder structure. Some files and folders such as the vagrant folder and guest OS console log file will only appear after provisioning the guest.

Always execute vagrant commands in the folder that defines the Vagrantfile configuration.

![Screenshot](https://raw.githubusercontent.com/kploesser/tomcat-util/master/img/img02.png)

### Install Vagrant Proxy Plugin (Untested)

Installs support for running vagrant commands behind a corporate proxy. Only required in case you are within a corporate network or in case you are connected to one via VPN.

Please note there are some know issues running this plugin on Windows machines.

```
vagrant plugin install vagrant-proxyconf

```

The plugin requires additional settings in your Vagrantfile before your can run provisioning.

```
config.proxy.http     = "http://yourproxy:8080"
config.proxy.https    = "http://yourproxy:8080"
config.proxy.no_proxy = "localhost,127.0.0.1"

```

### Vagrant Up
Navigate inside the tomcat-util folder to run the following commands.

```
cd tomcat-util

```

The vagrant up command creates the guest machine and provisions it with the necessary software. Provisioning is only done the first time you create a guest unless the provision flag is set. The first time you create a guest machine, Vagrant will download a copy of the guest OS image. This may take up to 45 minutes depending on the bandwidth and latency of your network. This step is only required once unless you remove the image from the host.

```
# Create guest machine (provisions only once)
vagrant up

# Force provisioning when booting the guest
vagrant up --provision

```

Vagrant up will run the provisioning script to install the necessary software components, configure users, and copy configuration files from the host directory to the guest. This may take some time depending on the bandwidth and latency of your network.

Vagrant displays messages while provisioning. The screenshot below shows the output of successfully provisioning a guest. You can now use the vagrant ssh command to log into the guest OS. The guest is fully self-contained, i.e., it starts Tomcat as a service during boot.

![Screenshot](https://raw.githubusercontent.com/kploesser/tomcat-util/master/img/img03.png)

### Log into the Guest (Optional)
You can log into the guest OS via SSH. Simply enter the following command in your prompt. Please note that additional configuration steps may be required on Windows for this to work.

You do not need to log into the guest OS unless you wish to make changes to it.

```
vagrant ssh

```

### Verify Your Installation
Tomcat is fully operational after successfully provisioning the guest machine. You can verify that your installation has succeeded by loading http://localhost:4000 in your browser. Refer to the Vagrant documentation on how to change port forwarding for your installation.
By default, the following settings are applied:

* Tomcat administration apps are accessible from outside the guest machine
* An administrator user is created (user: admin; password: admin)
* This user is assigned privileges to access the manager apps on Tomcat’s homepage

You can change these settings by editing the files in the conf directory you cloned via Git. Note that if you changes these settings after successfully provisioning a guest, you will need to rerun provisioning via the vagrant up --provision command (i.e., force provisioning).

![Screenshot](https://raw.githubusercontent.com/kploesser/tomcat-util/master/img/img04.png)

### Vagrant Teardown
Vagrant provides three teardown commands to free up resources on the host. These are listed in the following beginning with the suspend command. Suspend saves the current state of the guest machine and stops it. Note that this will take up additional disk space.

```
vagrant suspend

```

The vagrant halt command gracefully shuts down the guest OS and powers down the guest machine. This allows you to cleanly start it again. No additional disk space is taken up.

```
vagrant halt

```

The vagrant destroy command removes all traces of the guest machine from the host. It stops the guest OS, powers down the guest machine, and removes all guest hard disks.

```
vagrant destroy --force

```

## Running the Demo

### Deploying WAR Files
You can deploy simple Java web applications via the built-in Tomcat manager interface. This interface is shown in the screenshot below. Simply select and deploy the corresponding file.

![Screenshot](https://raw.githubusercontent.com/kploesser/tomcat-util/master/img/img05.png)

### Deploying a Sample Application
Tomcat provides a sample web application file as part of its release documentation. You can download this file as per the screenshot and use it for veriyfing your Tomcat installation.

![Screenshot](https://raw.githubusercontent.com/kploesser/tomcat-util/master/img/img06.png)

### Running the Sample Application
After deploying the sample web application, it will become visible in the Tomcat manager interface. Either click on the hyperlink or type the URL below into your browser to start it.

![Screenshot](https://raw.githubusercontent.com/kploesser/tomcat-util/master/img/img07.png)

## Packaging and Deploying Demo VMs
To be added in future iterations …
