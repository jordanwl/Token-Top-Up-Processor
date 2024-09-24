# Company class represents a company from JSON data
class Company
  attr_reader :id, :name, :top_up

  def initialize(data)
    @id = data['id']
    @name = data['name']
    @top_up = data['top_up']
    @email_status = data['email_status']
  end

  # Check if the company can send emails
  # @return [Boolean] True if the company can send emails, false otherwise
  def can_send_email?
    @email_status
  end
end
