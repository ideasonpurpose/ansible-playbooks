##IOP’s Ansible Playbooks

This repository contains a set of Ansible playbooks we're evolving for managing user creation and workstation maintenence at [Ideas On Purpose][iop]. While the overall tasks are very specific to our needs, there's likely something here which might be helpful towards other goals.

This started out as a basic recipe to eliminate some of the repetitive drudgery of creating and setting up accounts, but it's becoming more of a general toolkit for all sorts of repetitive tasks.

Below are excessively complete instructions for setting up the controller and running the playbooks. Partly in case I forget, partly so I can ask someone else to do this for me.

### Initial Setup
These pre-run steps are annoying. I've tried mightily to get around them, but it seems like it's just easier to suck it up and deal with a little bit of manual configuration.

#### Target computer pre-run setup
The target playbooks are only tested against Mavericks.

1. Setup a plain administrator account, Ansible will configure other accounts through this one. The `admin.yml` playbook will flesh out this account.
2. Turn on **Remote Login** in **System Preferences** > **Sharing**.
3. Install XCode from the Mac App Store. Open Xcode, agree to the license agreement and let it finish installing.
4. Install the Xcode Command Line Tools from Xcode's **Preferences** > **Downloads** (I've found this method to be most dependable)

#### Controller Setup

This should be every step necessary to set up a clean Mavericks system to run the playbooks. This should only need to be done once.

1. Install Xcode from the Mac App Store
2. Install [Homebrew][]
3. `brew install python ssh-copy-id` (includes pip)
4. [Install Virtualenvwrapper][venvw install]
    1. `pip install virtualenvwrapper`
    2. Add the following three lines to `~/.bashrc` (or `~/.profile`)
 
            export WORKON_HOME=$HOME/.virtualenvs  
            export PROJECT_HOME=$HOME/Devel
            source /usr/local/bin/virtualenvwrapper.sh


5. Create a new virtualenv: `mkvirtualenv ansible`
6. Clone this repository: `git clone https://github.com/ideasonpurpose/ansible-playbooks.git`
7. `cd ansible-playbooks`
8. Install from the `requirements.txt` file: `pip install -r requirements.txt`

### Running the playbooks

These first steps make sure the controller can talk to the target and execute commands. 

#### First run 
1. Rename the `hosts_sample` document to `hosts` and enter the addresses of your target machines
2. Copy your SSH public key to the target: `ssh-copy-id admin@target-imac.local`
2. Copy the bootstrap.sh script to the target machine. SSH into the target and run the ruby script with sudo to configure the target's sudoers file.

        $ ssh-copy-id admin@imac-2.local
        $ scp bootstrap.rb admin@imac-2.local:
        $ ssh admin@imac-2.local
        imac-1.local$ sudo ruby bootstrap.rb
        imac-1.local$ logout

#### Account setup
1. Copy `vars/user_sample.yml` to `vars/user.yml` and update the user credentials
2. Configure the admin account:
    `ansible-playbook admin.yml --extra-vars "target=imac-2.local"`
3. Create and set up the user account:
    `ansible-playbook user.yml --extra-vars "target=imac-2.local"`


## Additional Notes

#### Playbooks
There are two main playbooks:

* **admin.yml**
    Sets up an admin account on the target computer with some of my preferred settings and tools. This can also be used to reset an admin account back to a clean state.
* **user.yml**
    Sets up the new user account and a bunch of default settings


### The hosts file

Hosts is simply an INI file listing known computers. It should look something like this:

    # file: hosts
    [imacs]
    imac-1.local
    imac-2.local

Ansible will ignore computers that do not appear in hosts.

### Targeting a single machine
Because these playbooks are potentially destructive, `hosts:` is declared with the `{{ target }}` variable. This way, the playbooks default to doing nothing instead of running on every machine in the office. Explicit wins.

A command targeted to one machine looks like this:

    $ ansible-playbook user.yml --extra-vars "target=imac-2.local"

The group could be just as easily targeted with `--extra-vars "target=imacs"` to create the user account on each computer

### Bootstrapping the first run

The `bootstrap.rb` script sets up ssh keys and adds the admin user to `sudoers`. This is necessary for playbooks to run without password prompts.

### Running Locally
The playbooks can also be run locally by adding `--connection=local` and targeting localhost: `--extra-vars "target=localhost"`


## Warning
I'm going to assume that if you've gone so far as to get Ansible running and have downloaded these playbooks, then you probably have a bit of an understanding about how this stuff works and how much damage it could do. But just in case, **These playbooks will remove data, destroy accounts and wreak havok if pointed to the wrong account.** Please be careful, keep backups and read the code before running it.

### Tasks
Here are a few of the things these playbooks accomplish:

* Configure an admin user account
* Set a default Dock (using a stripped down template plist)
* Set preferences in Finder and Safari to our preferred defaults (see [osx dotfiles][dotfiles])
* Reset Safari
* Reset admin account picture and desktop pattern
* Install [Homebrew][] and several packages from Homebrew
* <strike>Install [Homebrew Cask][cask] and several applications via Cask.</strike> <small>*might be too soon, will revisit*</small>
* Install modules with pip (from homebrew's /usr/local/bin)
* Modify default terminal settings
* Generate a pre-formatted email signature
* Generate a custom HTML welcome document


[iop]: http://ideasonpurpose.com
[dotfiles]: https://github.com/mathiasbynens/dotfiles/blob/master/.osx
[homebrew]: http://brew.sh
[cask]: https://github.com/phinze/homebrew-cask
[venvw]: https://bitbucket.org/dhellmann/virtualenvwrapper/
[venvw install]: http://virtualenvwrapper.readthedocs.org/en/latest/install.html
