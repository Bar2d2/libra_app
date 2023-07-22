require "cucumber/rails"
require "cucumber/rspec/doubles"
require "capybara-screenshot/cucumber"
require "email_spec/cucumber"
require 'database_cleaner/active_record'
require 'rack/test'

World(Rack::Test::Methods)
World(FactoryBot::Syntax::Methods)

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise RuntimeError("You need to add database_cleaner to your Gemfile "\
                     "(in the :test group) if you wish to use it.")
end
Around do |scenario, block|
  DatabaseCleaner.cleaning(&block)
end

Before do
  t = Time.local(2022, 5, 1, 10, 5, 0)
  Timecop.freeze(t)
end

After do
  Timecop.return
end

Capybara.default_driver = :selenium_chrome_headless
Capybara.register_driver :selenium_chrome_headless do |app|
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 300

  browser_options = Selenium::WebDriver::Chrome::Options.new
  browser_options.args << '--headless'
  browser_options.args << '--no-sandbox'
  browser_options.args << '--disable-gpu'
  browser_options.args << '--disable-dev-shm-usage'
  browser_options.args << '--window-size=1920,1080'

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    http_client: client,
    options: browser_options
  )
end

Capybara::Screenshot.prune_strategy = { keep: 20 }
Capybara::Screenshot.webkit_options = { width: 1920, height: 1080 }
Capybara::Screenshot.autosave_on_failure = true
Capybara::Screenshot.register_driver(:selenium_chrome_headless) do |driver, path|
  driver.browser.save_screenshot(path)
end