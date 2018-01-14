
# System authorization information
auth --enableshadow --passalgo=sha512

# graphical
text

# Run the Setup Agent on first boot
firstboot --disable

# Keyboard layouts
keyboard --vckeymap=fi --xlayouts='fi','us'

# System language
lang en_US.UTF-8

# Network information
# network  --bootproto=dhcp --ipv6=auto --onboot yes --activate

firewall --disabled

# Root password
# rootpw --plaintext password

# System services
services --disabled="chronyd" --enabled=NetworkManager,sshd,cloud-init,cloud-init-local,cloud-config,cloud-final

# System timezone
timezone Europe/Helsinki --isUtc

# System bootloader configuration
bootloader --location=mbr --timeout=1 --append="console=ttyS0,115200n8 console=tty0" 

# Partition clearing information
zerombr
clearpart --all

# Disk partitioning information
reqpart
part / --fstype="xfs" --size=100 --grow --fsoptions  "defaults,noatime"

# Repositories
repo --name=fedora-updates --baseurl=http://ftp.funet.fi/pub/mirrors/fedora.redhat.com/pub/fedora/linux/updates/27/x86_64/

selinux --disabled

%packages --excludedocs --instLangs=en --nocore --excludeWeakdeps
-aic94xx-firmware*
-alsa-*
-biosdevname
-btrfs-progs*
-dracut-network
-iprutils
-ivtv*
-iwl*firmware
-libertas*
-kexec-tools
-plymouth*
-postfix
-*fonts

grubby
kernel
initscripts
NetworkManager
iproute
dhcp-client
pciutils
dnf
wget
tar
rsync
openssh-server


# cloud-init does magical things with metadata, including provisioning
# a user account with ssh keys.
cloud-init

# this is used by openstack's cloud orchestration framework (and it's small)
heat-cfntools

# We need this image to be portable; also, rescue mode isn't useful here.
dracut-config-generic
-dracut-config-rescue

# Needed initially, but removed below.
firewalld

%end


%post --erroronfail

echo "Fill all the empty space on hard disk."
# This forces the filesystem to reclaim space from deleted files
dd bs=1M if=/dev/zero of=/var/tmp/zeros
rm -f /var/tmp/zeros
echo "(Ignore out-of-space error that was expected.)"
%end

reboot

