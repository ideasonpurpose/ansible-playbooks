Readme.md

This is a set of playbooks I'm evolving for managing user creation and workstation maintenence at [Ideas On Purpose][iop]. While the overall tasks are very specific to our needs, there's probably something here which may be helpful to others. 

This started out as a basic recipe to eliminate some of the repetitive drudgery of creating and setting up accounts, but it's becoming more of a general toolkit for all sorts of tasks that neeed to be repeated. 

### Notes
I haven't talked myself into adding the admin account to sudoers yet, so the main play will need a sudo password. 

The main hosts file is sloppier than I'd like. In most cases these plays apply to only one machine, so each computer is its own group. This is sloppier than I'd like, but it's been working and I haven't had reason to go back to fix it yet. 

Safari and Finder preferences can be reset if the user account already exists.

## Warning
I'm going to assume that if you've gone so far as to get Ansible running and have downloaded my playbooks, then you probably have a bit fo an understanding about how this stuff works. But just in case, **These playbooks will remove data, destroy accounts and wreak havok if 

### Tasks
* Setup ssh keys
* Create an admin user account (from credentials in account.yml)
* Set a default Dock (using a stripped down template plist)
* Set some preferences in Finder and Safari to our preferred defaults
* Reset Safari
* Generate a pre-formatted email signature
* Generate a custom RTF welcome document

[iop]: http://ideasonpurpose.com