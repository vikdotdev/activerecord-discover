class PrintSquelch
  def self.squelch_output
    # Store the original stderr and stdout in order to restore them later
    @@original_stderr = $stderr
    @@original_stdout = $stdout

    # Redirect stderr and stdout
    null_path = File.join(File.dirname(__FILE__), '..', 'log', 'null.txt')
    File.open(null_path, 'a') { |f| f.truncate(0) } unless File.exist?(null_path)

    $stderr = File.new(null_path, 'w')
    $stdout = File.new(null_path, 'w')
  end

  # Replace stderr and stdout so anything else is output correctly
  def self.unsquelch_output
    $stderr = @@original_stderr
    $stdout = @@original_stdout
    @@original_stderr = nil
    @@original_stdout = nil
  end
end

