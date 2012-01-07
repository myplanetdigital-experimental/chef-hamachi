Description
===========
Will eventually provide a resource for managing hamachi networks that a client is
connected to. Currently only installs Logmein Hamachi2 client from package.

Currently tested only on Ubuntu 8.04.2 (Hardy).

Requirements
============

Attributes
==========
`hamachi['version']`
Determines Hamachi client version to download. Currently must be set to most
recent or install fails, since Logmein removes previous filename.

`hamachi['nickname']`
Nickname seems by other clients on network. Defaults to `node['hostname']`.

`hamachi['logmein_account']`
Email address associated with a Logmein account, used to connect to the
account's networks. Depending on account settings, may required authorization
through web UI, before which connecting to networks will fail.

`hamachi['networks']`
Hash containing network names and associated passwords. If required, client
attachmment request must be approved through web UI before networks may be
connected.

`hamachi['ipaddress_ham0']`
The clients internal ip on the network. This is set in the recipe, and
not tunable.

Usage
=====

