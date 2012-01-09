Description
===========
Will eventually provide a resource for managing hamachi networks that a client is
connected to. Currently only installs Logmein Hamachi2 client from package.

Currently tested only on 64-bit Ubuntu 8.04.2 (Hardy) and 32-bit Ubuntu 10.04 (Lucid).

Requirements
============

While not required, the [network_addr](https://gist.github.com/1040543) Ohai plugin is highly recommended
to help retrieve the ip address of the hamachi interface.

## Cookbooks:

* `apt` recipe

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

Usage
=====

 * Unfortunately, this cookbook currently works only with networks that
   do NOT require manual approval (ie. doesn't use "hamachi do-join")

TODO
====

 * Allow a "wait for approval" process for networks like for account
   attachment (ie accommodate both "join" and "do-join" commands)
 * Allow lmi account attachment to be cancelled or changes if new
   account is specified (currently need to manually disconnect first.
 * Allow network list to be more idempotent (add and remove networks
   based on active list)
 * Find a way to fail/warn when account attachment fails (bad login)
 * Convert networks from attribute to databag for encryption
 * Create LWRP?
