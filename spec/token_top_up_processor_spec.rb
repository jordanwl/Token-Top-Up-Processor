require_relative '../token_top_up_processor'

RSpec.describe TokenTopUpProcessor do
  let(:users_data) do
    [
      { 'id' => 1, 'first_name' => 'John', 'last_name' => 'Doe', 'email' => 'john@example.com', 'company_id' => 1,
        'email_status' => true, 'active_status' => true, 'tokens' => 100 },
      { 'id' => 2, 'first_name' => 'Jane', 'last_name' => 'Smith', 'email' => 'jane@example.com', 'company_id' => 1,
        'email_status' => false, 'active_status' => true, 'tokens' => 50 }
    ]
  end

  let(:companies_data) do
    [
      { 'id' => 1, 'name' => 'Test Company', 'top_up' => 50, 'email_status' => true }
    ]
  end

  let(:processor) { TokenTopUpProcessor.new(users_data:, companies_data:) }

  describe '#process' do
    it 'generates the correct output' do
      output = processor.process
      expect(output).to include('Company Id: 1')
      expect(output).to include('Company Name: Test Company')
      expect(output).to include('Users Emailed:')
      expect(output).to include('Doe, John, john@example.com')
      expect(output).to include('Previous Token Balance, 100')
      expect(output).to include('New Token Balance 150')
      expect(output).to include('Users Not Emailed:')
      expect(output).to include('Smith, Jane, jane@example.com')
      expect(output).to include('Previous Token Balance, 50')
      expect(output).to include('New Token Balance 100')
      expect(output).to include('Total amount of top ups for Test Company: 100')
    end
  end
end
