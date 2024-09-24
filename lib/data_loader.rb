require 'json'

# DataLoader handles loading and validating JSON data
class DataLoader
  # Custom error class for validation errors
  class ValidationError < StandardError; end

  # Load and validate JSON data from a file
  # @param file_name [String] The name of the file to load
  # @return [Array<(Array<Hash>, Array<String>)>] An array containing:
  #   - valid_data [Array<Hash>] The data that passed validation
  #   - errors [Array<String>] Error messages for data that failed validation
  # @raise [JSON::ParserError] If the JSON is malformed
  def self.load_json(file_name)
    data = JSON.parse(File.read(file_name))
    validate_data(data, file_name)
  end

  # Validate data based on the file type
  # @param data [Array<Hash>] The data to validate
  # @param file_name [String] The name of the file (used to determine validation type)
  # @return [Array<(Array<Hash>, Array<String>)>] An array of valid data and error messages
  # @raise [ArgumentError] If the file type is unknown
  def self.validate_data(data, file_name)
    case File.basename(file_name)
    when 'users.json'
      validate_users(data)
    when 'companies.json'
      validate_companies(data)
    else
      raise ArgumentError, "Unknown file type: #{file_name}"
    end
  end

  # Validate user data
  # @param users [Array<Hash>] The user data to validate
  # @return [Array<(Array<Hash>, Array<String>)>] An array of valid users and error messages
  def self.validate_users(users)
    valid_users = []
    errors = []

    users.each_with_index do |user, index|
      validate_user(user)
      valid_users << user
    rescue ValidationError => e
      errors << "Error in user at index #{index}: #{e.message}"
    end

    [valid_users, errors]
  end

  # Validate company data
  # @param companies [Array<Hash>] The company data to validate
  # @return [Array<(Array<Hash>, Array<String>)>] An array of valid companies and error messages
  def self.validate_companies(companies)
    valid_companies = []
    errors = []

    companies.each_with_index do |company, index|
      validate_company(company)
      valid_companies << company
    rescue ValidationError => e
      errors << "Error in company at index #{index}: #{e.message}"
    end

    [valid_companies, errors]
  end

  # Validate a single user's data
  # @param user [Hash] The user data to validate
  # @raise [ValidationError] If the user data is invalid
  def self.validate_user(user)
    required_fields = %w[id first_name last_name email company_id email_status active_status
                         tokens]
    required_fields.each do |field|
      raise ValidationError, "Missing required field: #{field}" unless user.key?(field)
    end

    unless user['id'].is_a?(Integer) && user['id'].positive?
      raise ValidationError,
            'Invalid id: must be a positive integer'
    end
    unless user['company_id'].is_a?(Integer) && user['company_id'].positive?
      raise ValidationError,
            'Invalid company_id: must be a positive integer'
    end
    unless user['tokens'].is_a?(Integer) && user['tokens'] >= 0
      raise ValidationError,
            'Invalid tokens: must be a non-negative integer'
    end
    raise ValidationError, 'Invalid email_status: must be a boolean' unless boolean?(user['email_status'])
    raise ValidationError, 'Invalid active_status: must be a boolean' unless boolean?(user['active_status'])
  end

  # Validate a single company's data
  # @param company [Hash] The company data to validate
  # @raise [ValidationError] If the company data is invalid
  def self.validate_company(company)
    required_fields = %w[id name top_up email_status]
    required_fields.each do |field|
      raise ValidationError, "Missing required field: #{field}" unless company.key?(field)
    end

    unless company['id'].is_a?(Integer) && company['id'].positive?
      raise ValidationError,
            'Invalid id: must be a positive integer'
    end
    unless company['top_up'].is_a?(Integer) && company['top_up'].positive?
      raise ValidationError,
            'Invalid top_up: must be a positive integer'
    end
    raise ValidationError, 'Invalid email_status: must be a boolean' unless boolean?(company['email_status'])
  end

  # Check if a value is boolean
  # @param value [Object] The value to check
  # @return [Boolean] True if the value is boolean, false otherwise
  def self.boolean?(value)
    [true, false].include?(value)
  end
end
