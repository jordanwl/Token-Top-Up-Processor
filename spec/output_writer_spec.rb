require_relative '../lib/output_writer'

RSpec.describe OutputWriter do
  describe '.write' do
    it 'writes content to a file' do
      allow(File).to receive(:write)
      OutputWriter.write('Test content', 'test.txt')
      expect(File).to have_received(:write).with('test.txt', "\nTest content\n")
    end

    it 'handles write errors' do
      allow(File).to receive(:write).and_raise(IOError.new('Write error'))
      expect do
        OutputWriter.write('Test content', 'test.txt')
      end.to output(/Error writing to test.txt: Write error/).to_stdout
    end
  end
end
