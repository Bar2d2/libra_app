# frozen_string_literal: true

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
end
