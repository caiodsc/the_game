# frozen_string_literal: true

require 'shoulda-matchers'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    require 'active_record'
    with.library :active_record
    with.library :active_model
  end
end
