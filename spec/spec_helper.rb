# $:.push File.expand_path("../lib", __FILE__)
# require 'lib/mosaic_facebook'

require 'rubygems'
require 'bundler/setup'
require 'vcr'
Bundler.require(:default)

if RUBY_VERSION >= '1.9.3'
  require 'simplecov'
  require 'simplecov-rcov'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::RcovFormatter,
  ]

  SimpleCov.start do
    add_filter 'spec'
  end
else
  require 'rspec/autorun'
end

SPEC_DIR = File.dirname(__FILE__)
# lib_path = File.expand_path("#{SPEC_DIR}/../lib")
# $LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)
require "#{SPEC_DIR}/vcr/vcr"

require 'mosaic-facebook'
FACEBOOK_CONFIG = YAML.load(File.open("#{SPEC_DIR}/facebook_config.yml", 'r'))

RSpec.configure do |config|
  config.add_setting :access_token, :default => FACEBOOK_CONFIG["access_token"]
  config.add_setting :user_id, :default => FACEBOOK_CONFIG["user_id"]
  config.add_setting :page_id, :default => FACEBOOK_CONFIG["page_id"]
  config.add_setting :app_id, :default => FACEBOOK_CONFIG["app_id"]
  config.add_setting :app_secret, :default => FACEBOOK_CONFIG["app_secret"]
  config.add_setting :oauth_code, :default => FACEBOOK_CONFIG["oauth_code"]
  config.add_setting :oauth_redirect_url, :default =>  FACEBOOK_CONFIG['oauth_redirect_url']
  config.treat_symbols_as_metadata_keys_with_true_values = true
end
