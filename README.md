##IOP's Ansible Playbooks

This repository contains a set of Ansible playbooks we're evolving for managing user creation and workstation maintenence at [Ideas On Purpose][iop]. While the overall tasks are very specific to our needs, there's likely something here which might be helpful towards other goals. 

This started out as a basic recipe to eliminate some of the repetitive drudgery of creating and setting up accounts, but it's becoming more of a general toolkit for all sorts of repetitive tasks.

### Requirements

The managing computer should have Ansible 1.4.x installed. To keep my computer clean, I keep Ansible in a like-named virtualenv which can be activated through [virtualenvwrapper][venvw].

For Homebrew, Xcode must be installed. 

### Running the playbooks

Here are some excessively complete instructions for running these playbooks. Partly in case I forget, partly so I can ask someone else to do this for me. 

The pre-run steps are annoying. I've tried mightily to get around these, but it seems like it's just easier to suck it up and deal with XCode

#### Pre-run on the Target
1. Setup an administrator account, Ansible will connect to this one to configure everything else.
2. Install XCode, be sure to open it and agree to the license agreement (is this necessary or does the next step take care of this?)
3. Open a terminal and run `xcode-select --install`. 

#### Pre-run on the controller
1. [Install Virtualenvwrapper][venvw install]
2. Inside a clean virtualenv (`mkvirtualenv ansible`), install Ansible:
        `pip install ansible`
3. Clone this repository: ` git clone https://github.com/ideasonpurpose/ansible-playbooks.git`


#### First run
1. Add target machines to the `hosts` file in the playbook directory
2. Enable SSH (Remote Login) on target, transfer ssh keys from controller to target and add keys to target's `~/.ssh/authorized_keys` file. Authorized_keys should be chmod'd to 0600:
    
        # 1. Transfer local public key to target
        scp ~/.ssh/id_dsa.pub admin@imac-1.local:

        # 2. connect to target
        ssh admin@imac-1.local
        password:

        # create ssh directories and setup keys on target
        imac-1$ mkdir -p ~/.ssh
        imac-1$ chmod 0700 ~/.ssh
        imac-1$ cat id_dsa.pub >> .ssh/authorized_keys
        imac-1$ rm id_dsa.pub
        imac-1$ chmod 0600 .ssh/authorized_keys
        imac-1$ logout

#### Account setup
1. Copy `vars/user_sample.yml` to `vars/user.yml` and update the user credentials
4. If the target is clean, bootstrap it first:  
    `ansible-playbook bootstrap.yml -K --extra-vars "target=imac-2.local"`
5. Run `ansible-playbook account.yml --extra-vars "target=imac-2.local"`
6. If there's an admin account, set that up too:  
    `ansible-playbook admin.yml --extra-vars "target=imac-2.local"`



### Creating the hosts file

Hosts is simply an INI file listing known computers. It should look something like this:

    # file: hosts
    [imacs]
    imac-1.local
    imac-2.local

Ansible will ignore computers that do not appear in hosts.

### Targeting a single machine 
Because these playbooks are potentially destructive, `hosts:` is declared with the `{{ target }}` variable. This way, the playbooks default to doing nothing instead of running on every machine in the office. Explicit wins. 

A command targeted to one machine looks like this:

    $ ansible-playbook iop.yml --extra-vars "target=imac-2.local"

The group could be just as easily targeted with `--extra-vars "target=imacs"`.

### Bootstrapping the first run

The `bootstrap.yml` playbook is meant to be run once, on a clean system. The bootstrap playbook sets up ssh authorized_keys and adds the playbook's user to the remote sudoers with no `password`. This must be run with `-K` for the sudo password and it will fail the second time if the password is sent:

    ansible-playbook bootstrap.yml -K --extra-vars="target=imac-1.local"


### Running Locally
The playbooks can also be run locally by adding `--connection=local` and switching the target to localhost.

#### Playbooks
There are three main playbooks:

* **bootstrap.yml**  
    Sets up passwordless sudo for the calling user
* **account.yml**  
    Sets up the new user account and a bunch of default settings
* **admin.yml**  
    Sets up the admin account with some of my preferred settings and tools


## Warning
I'm going to assume that if you've gone so far as to get Ansible running and have downloaded these playbooks, then you probably have a bit of an understanding about how this stuff works and how much damage it could do. But just in case, **These playbooks will remove data, destroy accounts and wreak havok if pointed to the wrong account.** Please be careful, keep backups and read the code before running it.

### Tasks
Here are a few of the things these playbooks accomplish:

* Modify sudoers for passwordless sudo from the admin account
* Create an admin user account (from credentials in account.yml)
* Set a default Dock (using a stripped down template plist)
* Set preferences in Finder and Safari to our preferred defaults (see [osx dotfiles][dotfiles])
* Reset Safari
* Reset admin account picture and desktop pattern
* Install [Homebrew][] and several packages from Homebrew
* Install [Homebrew Cask][cask] and several applications via Cask.
* Install modules with pip (from homebrew's /usr/local/bin)
* Modify default terminal settings
* Generate a pre-formatted email signature
* Generate a custom RTF welcome document

[iop]: http://ideasonpurpose.com
[dotfiles]: https://github.com/mathiasbynens/dotfiles/blob/master/.osx
[homebrew]: http://brew.sh
[cask]: https://github.com/phinze/homebrew-cask
[venvw install]: http://virtualenvwrapper.readthedocs.org/en/latest/install.html
