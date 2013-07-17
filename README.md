##IOP's Ansible Playbooks

This is a set of playbooks we're evolving for managing user creation and workstation maintenence at [Ideas On Purpose][iop]. While the overall tasks are very specific to our needs, there's probably something here which may be helpful to others. 

This started out as a basic recipe to eliminate some of the repetitive drudgery of creating and setting up accounts, but it's becoming more of a general toolkit for all sorts of tasks that neeed to be repeated. 

### Running the playbook

1. Add target machine to the `hosts` file
1. Setup user credentials in `accounts.yml`
2. `ansible-playbook iop.yml -K`

### Creating the `hosts` file

The initial set of tasks is pretty much targeted to one machine at a time, and I haven't great way of dealing with that yet. For now, each machine is entered as a group with one host, something like this:

    [imac22]
    imac-22.local

This is sloppier than I'd like, but it's been working and I haven't had reason to go back to fix it yet. 

### Notes
I haven't talked myself into adding the admin account to sudoers yet, so the main play will need a sudo password. Run it with the `-K` flag.

Safari and Finder preferences can be reset if the user account already exists.

## Warning
I'm going to assume that if you've gone so far as to get Ansible running and have downloaded these playbooks, then you probably have a bit of an understanding about how this stuff works and how much damage it could do. But just in case, **These playbooks will remove data, destroy accounts and wreak havok if pointed to the wrong account.** Please be careful, keep backups and read the code before running it.

### Tasks
* Setup ssh keys
* Create an admin user account (from credentials in account.yml)
* Set a default Dock (using a stripped down template plist)
* Set some preferences in Finder and Safari to our preferred defaults
* Reset Safari
* Generate a pre-formatted email signature
* Generate a custom RTF welcome document

[iop]: http://ideasonpurpose.com