Ministère du Dévelopement Durable
=================================

Setup
-----

### You'll need

  * ruby 1.9.3
  * the bundler gem
  * postgresql

### Install (debian)

1. Install the necessary packages:

    aptitude install postgresql postgresql-server-dev-9.1 postgresql-client

2. Once you have postgresql installed, create the `mdd` user:

    sudo su postgres
    createuser mdd
    exit

3. Edit /etc/postgresql/9.1/main/pg_hba.conf to authorize non unix users to authenticate.
   To do so, change `peer` to `trust` :

    # TYPE  DATABASE        USER            ADDRESS                 METHOD

    # "local" is for Unix domain socket connections only
    local   all             all                                     trust

4. Install the necessary gems via bundler:

    bundle install

5. Copy `database.yml.sample` file:

    cp config/database.yml.sample config/database.yml

6. Create the database:

    rake db:create

Run
---

    rails s thin

