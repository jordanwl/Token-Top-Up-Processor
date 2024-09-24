require_relative 'token_top_up_processor'
require_relative 'data_loader'
require_relative 'output_writer'

require 'fileutils'

begin
  # Load and validate data
  users_data, user_errors = DataLoader.load_json('input/users.json')
  companies_data, company_errors = DataLoader.load_json('input/companies.json')

  # Check for validation errors
  if user_errors.any? || company_errors.any?
    puts 'Errors found:'
    user_errors.each { |error| puts "User data: #{error}" }
    company_errors.each { |error| puts "Company data: #{error}" }
    raise 'Cannot proceed due to validation errors'
  end

  # Process data
  processor = TokenTopUpProcessor.new(users_data:, companies_data:)
  output = processor.process

  # Write output
  FileUtils.mkdir_p('output')
  OutputWriter.write(output, 'output/output.txt')

  puts 'Processing complete. Please check output/output.txt for results.'
rescue StandardError => e
  puts "An error occurred: #{e.message}"
end
