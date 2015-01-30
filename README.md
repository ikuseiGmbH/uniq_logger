# UniqLogger

- Add entries to an logfile, only if an uniq id is not already used.
- automaticaly generate logfile rotations: new logfile für every day, motnh or year
- send your logentries to another server per api using the same gem once as client and as a server
- creates an CSV formated file which can be easely opened in e.g. Excel for endusers

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'uniq_logger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install uniq_logger

## Usage

Create a configuration file config/uniq_logger.yml (view section 'Configuration')

To create a logentry use:

```ruby
require 'uniq_logger'
uniq_logger = UniqLogger.new
uniq_logger.create("UniqID", ["data","to","save"] )
```

## Configuration File

app/config/uniq_logger.yml

```yml
#Use a additional Log-Rotator which generates new logfiles for ['day','month','year'].
#Default 'none'
log_rotator: "month"

#If log_rotator is set, this will be the prefix for the file name 
log_rotator_prefix: "uniq_logger-"


#Use a global LogFile [true,false]. Chech for existin logs only looks in global logfile
#Default true
global_logger: true

#Name of the logfile to write to
global_log_file_name: "uniq_logger.log"


#if set to true, logentry creation returns 'false' if a logentry already exists with this ID
# This is only on global Logfiles possible
validates_uniqness_of_id: true

#If a local Logfile should be created or a ftp Account ['local', 'remote']
logfile_destination: "local"

#Path where Logfiles should be saved
path_to_local_logfiles: "../log/"

#If logfile_destination is set to 'remote' use folloing api credentials
remote:
  auth_token: "xyz123abc"
  server: "http://www.server.de"
  endpoint: "/api/v1/logger"
  url_param_for_id: "id"
  url_param_for_data: "data"
  basic_auth:
    username: ""
    password: ""

#CSV Export Settings: Encoding Type (default 'utf8'), Column Separator (default ';')
csv:
  encoding: "UTF8"
  col_sep: ";"
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/uniq_logger/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
