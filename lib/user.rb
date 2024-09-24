# User class represents an individual user from JSON data
class User
  attr_reader :first_name, :last_name, :email, :company_id, :active_status, :tokens

  def initialize(data)
    @id = data['id']
    @first_name = data['first_name']
    @last_name = data['last_name']
    @email = data['email']
    @company_id = data['company_id']
    @active_status = data['active_status']
    @email_status = data['email_status']
    @tokens = data['tokens']
  end

  # Check if the user can receive emails
  # @return [Boolean] True if the user can receive emails, false otherwise
  def can_receive_email?
    @email_status
  end
end
