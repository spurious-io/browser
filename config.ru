$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'aws-sdk'
require 'spurious/ruby/awssdk/helper'

AWS.config({
  :access_key_id     => 'development_access',
  :secret_access_key => 'development_secret',
  :region            => 'eu-westi-1'
})

Spurious::Ruby::Awssdk::Helper.configure

require 'app'
run App.new
