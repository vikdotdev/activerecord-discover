RSpec.configure do |config|
  config.mock_with :rspec
  config.order = "random"
  config.filter_run_when_matching :focus
  config.run_all_when_everything_filtered = true
  config.example_status_persistence_file_path = 'spec/log/examples.txt'
  config.expect_with :minitest
end

