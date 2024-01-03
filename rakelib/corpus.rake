require 'benchmark'

namespace :corpus do

  task :load_mail do
    require_relative '../spec/environment'
    require 'mail'
  end

  # Used to run parsing against an arbitrary corpus of email.
  # For example: http://plg.uwaterloo.ca/~gvcormac/treccorpus/
  desc "Provide a LOCATION=/some/dir to verify parsing in bulk, otherwise defaults"
  task :verify_all => :load_mail do

    root_of_corpus    = ENV['LOCATION'] || 'corpus/spam'
    @save_failures_to = ENV['SAVE_TO']  || 'corpus/failed_emails'
    @failed_emails    = []
    @checked_count    = 0

    if root_of_corpus
      root_of_corpus = File.expand_path(root_of_corpus)
      if not File.directory?(root_of_corpus)
        raise "\n\tPath '#{root_of_corpus}' is not a directory.\n\n"
      end
    else
      raise "\n\tSupply path to corpus: LOCATION=/path/to/corpus\n\n"
    end

    puts "Mail which fails to parse will be saved in '#{@save_failures_to}'"
    puts "Checking '#{root_of_corpus}' directory (recursively)"

    elapsed = Benchmark.realtime { dir_node(root_of_corpus) }

    puts "\n\n"

    if @failed_emails.any?
      report_failures_to_stdout
    end
    puts "Out of Total: #{@checked_count}"
    puts 'Elapsed: %.2f ms' % (elapsed * 1000.0)
  end

  def dir_node(path)
    puts "\n\n"
    puts "Checking emails in '#{path}':"

    entries = Dir.entries(path)

    entries.each do |entry|
      next if ['.', '..'].include?(entry)
      full_path = File.join(path, entry)

      if File.file?(full_path)
        file_node(full_path)
      elsif File.directory?(full_path)
        dir_node(full_path)
      end
    end
  end

  def file_node(path)
    verify(path)
  end

  def verify(path)
    result, exception = parse_as_mail(path)
    if result
      print '.'
    else
      save_failure(path, exception)
      print 'x'
    end
  end

  def save_failure(path, exception)
    @failed_emails << [path, exception]
    if @save_failures_to
      email_basename = File.basename(path)
      failure_as_filename = exception.message.gsub(/\W/, '_')
      new_email_name = [failure_as_filename, email_basename].join("_")
      FileUtils.mkdir_p(@save_failures_to)
      File.open(File.join(@save_failures_to, new_email_name), 'w+') do |fh|
        fh << File.read(path)
      end
    end
  end

  def parse_as_mail(path)
    @checked_count += 1
    Mail.read(path)
    [true, nil]
  rescue => e
    [false, e]
  end

  def report_failures_to_stdout
    @failed_emails.each do |path, exception|
      puts "#{path}: #{exception.message}\n\t#{exception.backtrace.join("\n\t")}"
    end
    puts "Failed: #{@failed_emails.size}"
  end
end
