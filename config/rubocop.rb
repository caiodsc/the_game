# frozen_string_literal: true

Rails.application.configure do
  config.generators.after_generate do |files|
    parsable_files = files.filter { |file| file.end_with?('.rb') }
    system("bundle exec rubocop -A --fail-level=E #{parsable_files.shelljoin}", exception: true) unless parsable_files.empty?
  end
end
