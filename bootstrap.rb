#! /usr/bin/env ruby

# This script assumes the controller's SSH key is in the same directory as itself
# See https://github.com/ideasonpurpose/ansible-playbooks for more info

require 'fileutils'
require 'etc'
require 'date'
include FileUtils


# Get the name and group from the ssh user's home directory
home_stat = File.stat(File.expand_path '~')
ssh_user = Etc.getpwuid(home_stat.uid).name
ssh_group = Etc.getgrgid(home_stat.gid).name

# Check for the public key, fail if it's not there
dsa_key_file = 'id_dsa.pub'

if !File.file?(dsa_key_file)
    puts "Error: Couldn't find %s in the current directory." % dsa_key_file
    exit!
end

# Create the .ssh directory if it doesn't exist
ssh_path = "#{Dir.home}/.ssh"
mkdir_p ssh_path
chmod(0700, ssh_path)
chown_R(ssh_user, ssh_group, ssh_path)

# Append the transferred public key to authorized_keys (or create the file with the key)
dsa_key = File.read(dsa_key_file)
rm dsa_key_file

authorized_keys = File.open "#{ssh_path}/authorized_keys", 'a+'
if !authorized_keys.readlines.include? dsa_key
    authorized_keys.puts dsa_key
    authorized_keys.chmod 0600
    authorized_keys.chown(ssh_user, ssh_group)
end

sudoers = File.read('/etc/sudoers')
#
sudoers_cmd = "#{ssh_user} ALL=(ALL) NOPASSWD: ALL\n"
sudoers_regexp=/^{ssh_user}\s+ALL=\(ALL\) NOPASSWD: ALL/

if !sudoers_regexp.match(sudoers)
    cp('/etc/sudoers', "/etc/sudoers.#{DateTime.now.strftime('%F@%H%M%S')}")
    File.open('/etc/sudoers', 'a+') {
        |f| f.puts(sudoers_cmd)
    }
end
