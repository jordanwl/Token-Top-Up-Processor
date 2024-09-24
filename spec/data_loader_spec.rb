require_relative '../data_loader'

RSpec.describe DataLoader do
  describe '.validate_user' do
    it 'validates a correct user' do
      user = { 'id' => 1, 'first_name' => 'John', 'last_name' => 'Doe', 'email' => 'john@example.com',
               'company_id' => 1, 'email_status' => true, 'active_status' => true, 'tokens' => 100 }
      expect { DataLoader.validate_user(user) }.not_to raise_error
    end

    it 'raises an error for an invalid user' do
      user = { 'id' => 'invalid', 'first_name' => 'John' }
      expect { DataLoader.validate_user(user) }.to raise_error(DataLoader::ValidationError)
    end
  end

  describe '.validate_company' do
    it 'validates a correct company' do
      company = { 'id' => 1, 'name' => 'Test Company', 'top_up' => 50, 'email_status' => true }
      expect { DataLoader.validate_company(company) }.not_to raise_error
    end

    it 'raises an error for an invalid company' do
      company = { 'id' => 'invalid', 'name' => 'Test Company', 'top_up' => 50, 'email_status' => true }
      expect { DataLoader.validate_company(company) }.to raise_error(DataLoader::ValidationError)
    end
  end
end
