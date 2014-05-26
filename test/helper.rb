require 'rubygems/commands/webhook_command'
require 'rubygems/commands/yank_command'
require 'shoulda'
require 'active_support'
require 'active_support/test_case'
require 'webmock'
require 'rr'

defined?(Minitest) ? (require 'minitest/autorun') : (require 'test/unit')

WebMock.disable_net_connect!

class CommandTest < ActiveSupport::TestCase
  include RR::Adapters::TestUnit unless include?(RR::Adapters::TestUnit)
  include WebMock::API

  def teardown
    WebMock.reset!
  end
end

def stub_api_key(api_key)
  file = Gem::ConfigFile.new({})
  stub(file).rubygems_api_key { api_key }
  yield file if block_given?
  stub(Gem).configuration { file }
end

def assert_said(command, what)
  assert_received(command) do |command|
    command.say(what)
  end
end

def assert_never_said(command, what)
  assert_received(command) do |command|
    command.say(what).never
  end
end
