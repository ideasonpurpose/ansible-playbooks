Readme.md

This is a set of playbooks I'm evolving for managing user creation and workstation maintenence at [Ideas On Purpose][iop]. While the overall tasks are very specific to our needs, there's probably something here which may be helpful to others. 

### Notes
I haven't talked myself into adding the admin account to sudoers yet, so the main play will need a sudo password. 

The main hosts file is sloppier than I'd like. In most cases these plays apply to only one machine, so each computer is its own group. This is sloppier than I'd like, but it's been working and I haven't had reason to go back to fix it yet. 

Safari and Finder preferences can be reset if the user account already exists.


### Tasks
* Setup ssh keys
* Create an admin user account (from credentials in account.yml)
* Set a default Dock (using a stripped down template plist)
* Set some preferences in Finder and Safari to our preferred defaults
* Generate a pre-formatted email signature

[iop]: http://ideasonpurpose.com