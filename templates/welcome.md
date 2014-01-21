<!-- This file is used to generate the HTML template used by the playbooks --> 
<link rel="stylesheet" href="http://yui.yahooapis.com/pure/0.3.0/pure-min.css">


### Your IOP Accounts

The account login for your computer is:

> **Username:**  `{{ username }}`  
> **Password:**  `{{ password }}`

Most all IOP services can be accessed using this password and username. Please keep your password private. 


### IOP Fileserver
IOP Fileserver and Photo Bank can be accessed with the above login. To connect to the server, choose **Connect to Server...** from the Finder's **Go** menu. The server's address is: <a href="{{ fileserver_address }}">{{ fileserver_address }}</a>

Please see the *IOP Server and File Name Conventions* document for more information about where to put files on the server and how they should be named.


### Email
Your email is already set up on your computer. Below are the settings you'll need to access your IOP email account from other devices. Our email uses Exchange and should auto-configure with these settings:

> **Address & Username:**  `{{ username }}@ideasonpurpose.com`  
> **Password:**  `{{ password }}`  

IOP's webmail can be accessed at <a href="{{ webmail_url }}">{{ webmail_url }}</a>, login with your full email address and password. 


### Wi-Fi
The Ideas On Purpose wireless network password is:  `{{ wifi_password }}`


### Google Apps
IOP's Google Apps URL is <a href="{{ google_apps_url }}">{{ google_apps_url }}</a>. Login with your email address and password. 


### Fonts
An "IOP Font Library" folder containing an extensive library of fonts can be found at the top level of your hard drive. Use OpenType format fonts. Legacy formats (Truetype, PostScript) should only be used as a last resort.

IOP recommends Font Book for font management, but we're open to other solutions. 

Please talk to Joe Maller if you need to install any additional applications or utilities.   
