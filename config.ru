$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'aws-sdk'
require 'spurious/ruby/awssdk/helper'

config_type = ENV['CONTAINER_BASED'].nil? ? :cli : :docker

Spurious::Ruby::Awssdk::Helper.configure config_type

require 'app'
require 'routes/dynamodb'
require 'routes/s3'
require 'routes/sqs'

map("/") { run Spurious::Browser::App }
map("/dynamodb") { run Spurious::Browser::Routes::Dynamodb }
map("/s3") { run Spurious::Browser::Routes::S3 }
map("/sqs") { run Spurious::Browser::Routes::SQS }
