This project uses Vagrant to setup a wise4 virtual machine.

Prerequisites

- git
- ruby - on a mac this is already installed
- vagrant - run "sudo gem install vagrant" (if you are using rvm just do "gem install vagrant")
- virtualbox - http://www.virtualbox.org/wiki/Downloads

Then to try it out:

    git clone git://github.com/concord-consortium/wise4-vagrant.git
    vagrant up  # the first time you do this will take a while downloading a base virtual box and then setting it up
    open "http://localhost:4567/webapp/index.html"
