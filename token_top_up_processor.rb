require_relative 'user'
require_relative 'company'

# UserProcessor handles the processing of user and company data
class TokenTopUpProcessor
  # Initialize the processor with user and company data
  # @param users_data [Array<Hash>] The raw user data from the JSON file
  # @param companies_data [Array<Hash>] The raw company data from the JSON file
  def initialize(users_data:, companies_data:)
    @users_data = users_data
    @companies_data = companies_data
  end

  # Process the raw data and generate the formatted output
  # @return [String] The formatted output string
  def process
    companies = create_companies.sort_by(&:id)

    # users will be sorted by last name, first_name in categorize_users
    users = create_users

    companies.map { |company| generate_company_report(company, users) }
             .compact
             .join("\n\n")
  end

  private

  # Create User objects from raw user data
  # @return [Array<User>] Array of User objects
  def create_users
    @users_data.map { |user_data| User.new(user_data) }
  end

  # Create Company objects from raw company data and sort them
  # @return [Array<Company>] Array of Company objects
  def create_companies
    @companies_data.map { |company_data| Company.new(company_data) }
  end

  # Generate a report for a single company and its users
  # @param company [Company] The company to process
  # @return [String] The formatted output for the company
  def generate_company_report(company, users)
    company_users = users.select { |user| user.company_id == company.id && user.active_status }
    return nil if company_users.empty?

    emailed_users, not_emailed_users = categorize_users(company, company_users)
    total_top_up = company.top_up * company_users.count
    
    generate_company_output(company, emailed_users, not_emailed_users, total_top_up)
  end

  # Categorize users into emailed and not emailed groups
  # @param company [Company] The company the users belong to
  # @param users [Array<User>] The users to process
  # @return [Array<Array<String>>] Two arrays of user output strings, for emailed and not emailed users
  def categorize_users(company, users)
    emailed_users = []
    not_emailed_users = []

    users.each do |user|
      previous_balance = user.tokens
      new_balance = user.tokens + company.top_up

      user_output = generate_user_output(user, previous_balance, new_balance)

      if company.can_send_email? && user.can_receive_email?
        emailed_users << [user, user_output]
      else
        not_emailed_users << [user, user_output]
      end
    end

    [
      emailed_users.sort_by { |user, _| [user.last_name, user.first_name] }.map(&:last),
      not_emailed_users.sort_by { |user, _| [user.last_name, user.first_name] }.map(&:last)
    ]
  end

  # Generate the output string for a single user
  # @param user [User] The user to generate output for
  # @param previous_balance [Integer] The user's previous token balance
  # @param new_balance [Integer] The user's new token balance
  # @return [String] The formatted user output
  def generate_user_output(user, previous_balance, new_balance)
    [
      "\t\t#{user.last_name}, #{user.first_name}, #{user.email}",
      "\t\t  Previous Token Balance, #{previous_balance}",
      "\t\t  New Token Balance #{new_balance}"
    ].join("\n")
  end

  # Generate the output string for a single company
  # @param company [Company] The company to generate output for
  # @param emailed_users [Array<String>] The output strings for emailed users
  # @param not_emailed_users [Array<String>] The output strings for not emailed users
  # @param total_top_up [Integer] The total amount of tokens topped up for the company
  # @return [String] The formatted company output
  def generate_company_output(company, emailed_users, not_emailed_users, total_top_up)
    [
      "\tCompany Id: #{company.id}",
      "\tCompany Name: #{company.name}",
      "\tUsers Emailed:",
      emailed_users.empty? ? '' : emailed_users.join("\n"),
      "\tUsers Not Emailed:",
      not_emailed_users.empty? ? '' : not_emailed_users.join("\n"),
      "\t\tTotal amount of top ups for #{company.name}: #{total_top_up}"
    ].reject(&:empty?).join("\n")
  end
end
