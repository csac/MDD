Ministère du Développement Durable
=================================

Setup
-----

### You'll need

  * ruby 1.9.3
  * the bundler gem
  * postgresql

### Install (debian)

* Install the necessary packages:

```
aptitude install postgresql postgresql-server-dev-9.1 postgresql-client
```

* Once you have postgresql installed, create the `mdd` user:

```
sudo su postgres
createuser mdd
exit
```

* Edit `/etc/postgresql/9.1/main/pg_hba.conf` to authorize non unix users to authenticate.
   To do so, change `peer` to `trust` :

```
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     trust
```

* Restart postgresql for config change:
``` bash
/etc/init.d/postgresql restart
```

* Install the necessary gems via bundler:

```
bundle install
```

* Copy `database.yml.sample` file:

```
cp config/database.yml.sample config/database.yml
```

* Create the database and run migrations:

```
bundle exec rake db:setup
bundle exec rake db:migrate
```

Create user
-----------

``` bash
bundle exec rails c
>> User.find_or_initialize_by_email("admin@developpement-durable.gouv.fr")
>> u.password = 'password' # => "password"
>> u.roles = [:administrator] #=> [:administrator]
>> u.save # => true
```

Run
---

```
bundle exec rails s thin
```
