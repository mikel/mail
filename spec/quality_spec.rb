RSpec.describe do
  it "has no trailing whitespaces" do
    failed = Dir["lib/{**/,}*.rb"].reject { |x| x.include?("/machines/") }.select do |file|
      File.readlines(file).each_with_index.map do |line,number|
        if line =~ /[ \t]+$/
          warn "Trailing whitespace on #{file}:#{number + 1}"
          true
        end
      end.any?
    end
    expect(failed).to eq([])
  end
end
