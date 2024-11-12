# frozen_string_literal: true

require 'password_blocklist/version'
require 'password_blocklist/checker'

begin
  require 'active_model'
  require 'password_blocklist/validator'

  # # Load the I18n validation error messages
  require 'active_support/i18n'
  I18n.load_path.concat Dir[File.expand_path("locale/*.yml", __dir__)]
rescue LoadError
  # Do nothing for non Rails projects
end

module PasswordBlocklist
  module_function

  def blocklisted?(password, list_size = :md)
    Checker.new.blocklisted?(password, list_size)
  end
end
