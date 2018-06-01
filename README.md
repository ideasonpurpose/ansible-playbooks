# IOP’s Ansible Playbooks

This evolving set of Ansible playbooks automates Mac user creation and designer workstation maintenance at [Ideas On Purpose][iop]. While these are ultimately very specific to our needs, there's likely something here which will be helpful in other situations.

A few of the things these playbooks accomplish:

* Configure an admin user account
* Reset admin account picture and desktop pattern
* Set a default Dock from a simple Yaml list
* Set preferences in Finder and Safari to our preferred defaults (see [macos dotfiles][dotfiles])
* Reset Safari
* Disable first-login iCloud popups (thanks to [Rich Trouton][rtrouton])
* Install [Homebrew][] and several packages from Homebrew
* Tweak Homebrew to run for multiple users
* Install [Homebrew Cask][cask] and several common applications via Cask
* Pre-install several Sublime Text packages
* Clear out some common Adobe cruft and install leftovers
* Modify default terminal settings
* Generate a pre-formatted email signature
* Generate a welcome document from a custom HTML template.

The playbooks have been updated for macOS High Sierra. They are likely to be compatible with ealier macOS releases (this project first ran on Mavericks), though testing is limited to the current release. Playbook execution time is dependent on the target computer state (how much needs doing), target CPU and network bandwidth but usually takes 5-10 minutes.

### The Playbooks

There are two main playbooks:

* **admin.yml**
    Sets up an admin account on the target computer with some preferred settings and tools. This can also reset an admin account back to a clean state. *This playbook deletes everything in `~/Desktop`.*

* **user.yml**
    Sets up the new user account and a bunch of default settings. These are primarily used by designers. 

Below are excessively complete instructions for setting up the controlling computer and running the playbooks. Partly in case I forget, partly so I can ask someone else to do this for me.

### Initial Setup
Pre-run steps are annoying. I've tried mightily to get around these, but it seems like it's just easier to suck it up and deal with a little bit of manual configuration.

#### Target computer pre-run setup

1. Setup a plain administrator account, Ansible will configure other accounts through this one. The `admin.yml` playbook will flesh out this account.
2. Set the computer's name in **System Preferences** > **Sharing**. Make a note of the local hostname, a computer named "iMac 3" will probably have the local hostname `imac-3.local`. Ansible will find the target computer by its local hostname or IP address.
3. Turn on **Remote Login** in **System Preferences** > **Sharing** to enable SSH connections.
4. Install **Command Line Tools for Xcode** by running `xcode-select --install` in **Terminal** and following the prompts. 

#### Controller Setup

The controller is the computer the playbooks are run from (eg. *your* computer). This should be every step necessary to set up a clean macOS system to run the playbooks. This should only need to be done once.

1. Install **Command Line Tools for Xcode** by running `xcode-select --install` in **Terminal**
2. Install [Homebrew][]
3. `brew install pandoc ssh-copy-id`
4. Install [Ansible from source](http://docs.ansible.com/ansible/intro_installation.html)
    * clone `git clone https://github.com/ansible/ansible.git`
    * `git submodule update --init --recursive`
    * `source hacking/env-setup`
6. Clone this repository: 
    *  `git clone https://github.com/ideasonpurpose/ansible-playbooks.git`
7. `cd ansible-playbooks`
8. Install from the `requirements.txt` file: `pip install -r requirements.txt`

### Running the playbooks

These first steps make sure the controller can talk to the target and execute commands. 

#### First run 

1. Rename the `hosts_sample` document to `hosts` and enter the addresses of your target machines and the name of the admin user.
2. Copy your SSH public key to the target:  
    `ssh-copy-id admin@target-imac.local`
3. Copy the `bootstrap.sh` script to the target machine. SSH into the target and run the ruby script with sudo to configure the target's sudoers file.

```
$ ssh-copy-id admin@imac-2.local
$ scp bootstrap.rb admin@imac-2.local:
$ ssh admin@imac-2.local
imac-1.local$ sudo ruby bootstrap.rb
imac-1.local$ logout
```
#### Account setup
1. Copy `vars/user_sample.yml` to `vars/user.yml` and update the user credentials
2. Configure the admin account:  
    `ansible-playbook --extra-vars "target=imac-2.local" admin.yml`
3. Create and set up the user account:  
    `ansible-playbook --extra-vars "target=imac-2.local" user.yml`


## Additional Notes


### The hosts file

Hosts is simply an INI file listing known computers. It should look something like this:

    # file: hosts
    [imacs:vars]
    admin_user=macadmin
    
    [imacs]
    imac-1.local
    imac-2.local

Ansible won't run on computers which don't appear in hosts.

The `:vars` section is used to define `admin_user` which should be an account which can run sudo commands.

### Targeting a single machine
Because these playbooks are potentially destructive, `hosts:` is declared with the `{{ target }}` variable. This way, [the playbooks default to doing nothing](http://stackoverflow.com/q/18195142) instead of running on every machine in the office. Explicit wins.

A command targeted to one machine looks like this:

    $ ansible-playbook --extra-vars "target=imac-2.local" user.yml

A group of hosts could be just as easily targeted with `--extra-vars "target=imacs"` to create the user account on each computer.

Specific admin users can also be set here instead of defining them in `host:vars`:

    $ ansible-playbook--extra-vars "target=imac-2.local admin_user=joe" user.yml 

### Bootstrapping the first run

The `bootstrap.rb` script sets up ssh keys and adds the admin user to `sudoers`. This is necessary for playbooks to run without password prompts.

### Running Locally
The playbooks can also be run locally by targeting localhost and setting connection to local:
    
    $ ansible-playbook --extra-vars "target=localhost" --connection=local user.yml

### User account images
The playbooks will randomly select a user image from any png images found in `files/admin_account_images` or `files/user_account_images`. If no images are found, the accounts will be created using the system placeholder image. 

### The Welcome Template
A simple `gulpfile` is included for working in the template. To create a custom welcome message, follow these steps:

1. Install dependencies by running `npm install` .
2. Copy `templates/src/welcome_sample.html.j2` to `templates/src/welcome.html.j2`
3. Run `gulp watch`
4. Open a web browser to [localhost:3000](http://localhost:3000) and start hacking away on the template files.

Gulp will compile changes to `templates/src/welcome.html.j2` into **`/templates/welcome.html.j2`**. Ansible will use the generated template.

### Admin accounts
Don't name your admin account `admin`. That's one of the first names automated attacks will try to connect to.

## Warning
Assuming you've gone so far as to get Ansible running and have downloaded these playbooks, you probably understand how this stuff works and how much damage it could do. But just in case, **These playbooks will remove data, destroy accounts and wreak havok if pointed to the wrong account.** Please be careful, keep backups and read the code before running it.

## About

[![iop_logo](https://cloud.githubusercontent.com/assets/8320/9443542/944a8bce-4a4f-11e5-9d2f-54999b1687d5.png)][iop]  
This project is sponsored by [Ideas On Purpose][iop].


[iop]: http://ideasonpurpose.com
[dotfiles]: https://github.com/mathiasbynens/dotfiles/blob/master/.macos
[homebrew]: http://brew.sh
[cask]: https://github.com/phinze/homebrew-cask
[venvw]: https://bitbucket.org/dhellmann/virtualenvwrapper/
[venvw install]: http://virtualenvwrapper.readthedocs.org/en/latest/install.html
[rtrouton]: http://derflounder.wordpress.com/2014/10/16/disabling-the-icloud-and-diagnostics-pop-up-windows-in-yosemite/
