WORKSTATION_OSTREE_CONFIG
----------------

This project is my custom workstation setup based on the immutuble OS Fedora Silverblue

Purpose
-----------------

The goal of the system is to be a workstation, using rpm-ostree for the base OS, and a combination of Docker and Flatpak containers, as well as virtualization tools such as Vagrant.

Status
------

This project is personal and for testing purposes but can be an inspiration for someone.
USE AT YOUR OWN RISK!

Installing
------------

Install Fedora Silverblue on a laptop machine.
1. Download a Silverblue image from [https://silverblue.fedoraproject.org/download](https://silverblue.fedoraproject.org/download)
2. Install on bare system or on a virtual machine
3. Choose default layout for disk but make sure it is encrypted
4. Make a default home user (in my case mto)  
5. Boot and login
6. cd $HOME
7. git clone https://github.com/mto79/workstation_ostree_config.git workstation_ostree_config 
8. cd $HOME/workstation_ostree_config 
9. ./compose.sh 

See the Silverblue [documentation](https://docs.fedoraproject.org/en-US/fedora-silverblue/installation-guide/.)

Important issues:
-----------------------

 - [flatpak system repo](https://github.com/flatpak/flatpak/issues/113#issuecomment-247022006)

Using the system
--------------------

One of the first things you should do use is use a container runtime of your
choice to manage one or more "pet" containers.  This is where you will use
`yum/dnf` to install utilities.

With `docker` for example, you can use the `-v /srv:/srv` command line option so
these containers can share content with your host (such as git repositories).
Note that if you want to share content between multiple Docker containers and
the host (e.g. your desktop session), you should execute (once):

```
sudo chcon -R -h -t container_file_t /var/srv
```

Next, let's try flatpak. Before you do: There's a known flatpak issue on
AtomicWS - run [this workaround](https://github.com/flatpak/flatpak/issues/113#issuecomment-247022006),
which you only need to do once. After that, [try flatpak](http://flatpak.org/apps.html).

If you are a developer for server applications,
try [oc cluster up](https://github.com/openshift/origin/blob/master/docs/cluster_up_down.md) to
create a local OpenShift v3 cluster.

Finally, try out `rpm-ostree install` to layer additional packages directly on
the host. This is needed for "host extensions" - privileged software that
doesn't make sense to live in a container. For example, `rpm-ostree install
powerline` to use that software for the shell prompts of the host.  Another
good example is `rpm-ostree install vagrant-libvirt` to use [Vagrant](https://www.vagrantup.com/)
to manage VMs.

Future work
-----------

 - GNOME Software support for both rpm-ostree/flatpak and possibly docker
 - automated tests that run on this content

After install
-----------
Run setup script ./$HOME/workstation_ostree_config/mto-setup.sh