#! /usr/bin/env ruby

# This script just adds the user running the script to /etc/sudoers
# See https://github.com/ideasonpurpose/ansible-playbooks for more info

require 'fileutils'
require 'etc'
require 'date'
include FileUtils


# Get the name and group from the ssh user's home directory
home_stat = File.stat(File.expand_path '~')
ssh_user = Etc.getpwuid(home_stat.uid).name
ssh_group = Etc.getgrgid(home_stat.gid).name

sudoers = File.read('/etc/sudoers')
sudoers_cmd = "#{ssh_user} ALL=(ALL) NOPASSWD: ALL\n"
sudoers_regexp=/^#{ssh_user}\s+ALL=\(ALL\) NOPASSWD: ALL/

# check first, no point in adding ourselves multiple times
if !sudoers_regexp.match(sudoers)
    # backup sudoers, just in case
    cp('/etc/sudoers', "/etc/sudoers.#{DateTime.now.strftime('%F@%H%M%S')}")
    File.open('/etc/sudoers', 'a+') {
        |f| f.puts(sudoers_cmd)
    }
end

# Remove Yo Self
rm __FILE__