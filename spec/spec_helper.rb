require 'bundler/setup'
require 'webmock/rspec'
require 'git_analysis'
require 'vcr'
require 'test/unit'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.expose_dsl_globally = true
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr"
  config.hook_into :webmock
end

# class VCR_response < Test::Unit::TestCase
#   def repo_info 
#     VCR.use_cassette("synopsis") do
#       response = Net::HTTP.get_response(URI('https://www.api.github.com/solidusio/solidus'))
#       assert_match /id/, response.body
#     end
#   end
# end