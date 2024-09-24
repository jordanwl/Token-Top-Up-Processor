# OutputWriter class handles writing the output to a file
class OutputWriter
  # Write the given content to a file, printing an error message if it fails
  # @param content [String] The content to write to the file
  # @param file_name [String] The name of the file to write to
  # @return [void]
  def self.write(content, file_name)
    File.write(file_name, "\n" + content + "\n")
  rescue IOError => e
    puts "Error writing to #{file_name}: #{e.message}"
  end
end
