# frozen_string_literal: true

require 'simplecov'

SimpleCov.start 'rails' do
  add_group 'Services', 'app/services'

  add_filter '/mailers/'
  add_filter '/channels/'

  add_filter do |source_file|
    source_file.lines.count < 5
  end
end
