WebDev Setup
============

This script prepares a web development environment in your Ubuntu (9.04 compatible).

![Select database](http://s.cleitonfco.com.br/i/wd-setup1.png)

What will be installed?
-----------------------

* Ruby
* Rails
* Git
* MySql*
* Postgres*
* Sqlite*
* Apache*
* NGinx*
* Passenger*
* PHP5
* Various Gems (of your choice)

\* Optional

Usage
-----

To run this script you should be logged as root (or sudoer user).

Now download the script installer and uncompress it.

    wget http://github.com/cleitonfco/webdev-setup/tarball/master -O webdev-setup.tar.gz
    tar xzf webdev-setup.tar.gz
    rm webdev-setup.tar.gz
    mv cleitonfco-webdev-setup* webdev-setup
    cd webdev-setup

Run `sudo bash install.sh` and answer to the config dialogs.

### ATTENTION

This script are still in development, any problems or questions, please report me.

TODO
----

* Add more gems
* Add essential plugins and styles in Gedit
* Add Java and Java plugin for Browsers

Author
------

Copyright © 2009 [Cleiton Francisco](http://cleitonfco.com.br/ "Author's Website"), released under the MIT license

LICENSE:
--------

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
