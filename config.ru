$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'aws-sdk'
require 'spurious/ruby/awssdk/helper'

AWS.config({
  :access_key_id     => 'development_access',
  :secret_access_key => 'development_secret',
  :region            => 'eu-west-1'
})

Spurious::Ruby::Awssdk::Helper.configure

require 'app'

map('/dynamodb') { run Spurious::Browser::Routes::Dynamodb }
map('/s3') { run Spurious::Browser::Routes::S3 }
