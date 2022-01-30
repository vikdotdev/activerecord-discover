Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.order = "random"
  config.filter_run_when_matching :focus
  config.run_all_when_everything_filtered = true
  config.example_status_persistence_file_path = 'spec/examples.txt'
end

RSpec::Matchers.define :a_callback_of_a_kind do |expected|
  match do |actual|
    actual.kind == expected
  end
end

RSpec::Matchers.define :a_callback_of_a_name do |expected|
  match do |actual|
    actual.name == expected
  end
end

RSpec::Matchers.define :a_callback_including_if do |expected|
  match do |actual|
    Array.wrap(expected).map { |item| actual.ifs.include? item }.all?
  end
end

# gotcha, need a splat for multiple params here
RSpec::Matchers.define :a_callback_including_symbolic_if do |*expected|
  match do |actual|
    Array.wrap(expected).map { |item| actual.symbolic_ifs.include? item }.all?
  end
end

RSpec::Matchers.define :callback_including_proc_source do |*expected|
  match do |actual|
    Array.wrap(expected).map do |item|
      actual.proc_ifs.map { |if_cond| if_cond.source.include? item }.any?
    end.all?
  end
end

# RSpec::Matchers.define :callback_including_proc_source do |*expected|
#   match do |actual|
#     Array.wrap(expected).map do |item|
#       actual.proc_ifs.map { |if_cond| if_cond.source.include? item }.any?
#     end.all?
#   end
# end

# RSpec::Matchers.define :a_callback_of_type do |expected|
#   match do |actual|
#     actual.name == expected
#   end
# end
