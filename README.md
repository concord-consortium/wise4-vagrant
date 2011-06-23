This project uses Vagrant to setup a wise4 virtual machine.

Prerequisites

- git
- ruby - on a mac this is already installed
- vagrant - run "sudo gem install vagrant" (if you are using rvm just do "gem install vagrant")
- virtualbox - http://www.virtualbox.org/wiki/Downloads

Then to try it out:

    git clone [fill me in]
    vagrant up  # the first time you do this will take a while downloading a base virtual box and then setting it up
    open "http://localhost:4567/webapp/index.html"
