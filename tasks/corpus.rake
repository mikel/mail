namespace :corpus do

  task :load_mail do
    require File.expand_path('../../spec/environment', __FILE__)
    require 'mail'
    require 'mail/parsers'
  end

  require "net/http"
  require "net/https"
  require "uri"
  class CorpusDownloader

    def initialize
      @referer = "http://plg.uwaterloo.ca/cgi-bin/cgiwrap/gvcormac/foo"
      @archive_url = "http://plg.uwaterloo.ca/cgi-bin/cgiwrap/gvcormac/trec05p-1.tgz"
      @archive_checksum_url = "http://plg.uwaterloo.ca/~gvcormac/treccorpus/trec05p-1.MD5SUM"
      @archive_readme_url = "http://plg.uwaterloo.ca/~gvcormac/treccorpus/README.html"
    end

    def corpus_downloaded?
      File.exist?("corpus/spam/trec05p-1")
    end

    def download_and_move
      return if corpus_downloaded?
      FileUtils.mkdir_p("corpus/spam") # LOCATION
      FileUtils.mkdir_p("spec/fixtures/emails/failed_emails") # SAVE_TO
      puts "Deleting any previously failed emails"
      FileUtils.rm_f("spec/fixtures/emails/failed_emails/*")
      Dir.chdir("corpus/spam") do
        puts "Downloading corpus"
        @success = download_corpus
      end
      if @success == false
        exit 1
      elsif ! File.exist?("corpus/spam/trec05p-1")
        exit 2
      end
    end

    def download_corpus
      download_archive
      download_checksum
      download_readme
      verify_download
    end

    def verify_download
      # expected_hash=$(cat trec05p-1.MD5SUM | cut -d' ' -f1)
      # received_hash=$(cat trec05p-1.tgz | openssl dgst -md5)
      # if [ $expected_hash = $received_hash ]
      # then
      #   echo "Downloaded files with expected md5"
      #   tar xzf trec05p-1.tgz && true
      # else
      #   echo "Downloaded files failed to match expected md5"
      #   echo "'$expected_hash' != '$received_hash'"
      #   rm -f trec05p-1.tgz
      #   rm -f trec05p-1
      #   false
      # fi
    end

    def download_archive
      # response = download_url(@archive_url)
      # File.write(response.body, 
    end

    def download_checksum
      # response = download_url(@archive_checksum_url)
    end

    def download_readme
      # response = download_url(@archive_readme_url)
    end

    def download_url(url)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      if  http.use_ssl = (uri.scheme == 'https')
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      request = Net::HTTP::Get.new(uri.request_uri)
      request.initialize_http_header({
         "User-Agent" =>
         "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6",
           "Referer" => @referer,
           "Accept" => "text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5",
           "Accept-Language" => "en-us,en;q=0.5",
           "Accept-Encoding" => " gzip,deflate",
           "Accept-Charset" =>  "ISO-8859-1,utf-8;q=0.7,*;q=0.7",
           "Keep-Alive" => "300"
       })
       http.request(request)
    end

  end

  # Downloads and unpacks the spam corpus, if not present
  task :download_corpus => [] do
    downloader = CorpusDownloader.new
    downloader.download_and_move
  end

  # Usage: bash corpus.bash confirm_failures
  # Loops over email failures and outputs success or exception class
  task :confirm_failures => [:load_mail, :download_corpus] do
    Dir["spec/fixtures/emails/failed_emails/*"].each do |file|
      puts Mail.read(file) && "success" rescue $!.class
    end
  end

  # Used to run parsing against an arbitrary corpus of email.
  # For example: http://plg.uwaterloo.ca/~gvcormac/treccorpus/
  desc "Provide a LOCATION=/some/dir to verify parsing in bulk, otherwise defaults"
  task :verify_all => [:load_mail, :download_corpus] do

    root_of_corpus    = ENV['LOCATION'] || 'corpus/spam'
    @save_failures_to = ENV['SAVE_TO']  || 'spec/fixtures/emails/failed_emails'
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

    if @save_failures_to
      if not File.directory?(@save_failures_to)
        raise "\n\tPath '#{@save_failures_to}' is not a directory.\n\n"
      end
      @save_failures_to = File.expand_path(@save_failures_to)
      puts "Mail which fails to parse will be saved in '#{@save_failures_to}'"
    end

    puts "Checking '#{root_of_corpus}' directory (recursively)"

    # we're tracking all the errors separately, don't clutter terminal
    $stderr_backup = $stderr.dup
    $stderr.reopen("/dev/null", "w")
    STDERR = $stderr

    dir_node(root_of_corpus)

    # put our toys back now that we're done with them
    $stderr = $stderr_backup.dup
    STDERR = $stderr

    puts "\n\n"

    if @failed_emails.any?
      report_failures_to_stdout
    end
    puts "Out of Total: #{@checked_count}"

    if @save_failures_to
      puts "Add SAVE_TO=/some/dir to save failed emails to for review.,"
      puts "May result in a lot of saved files. Do a dry run first!\n\n"
    else
      puts "There are no errors"
    end
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
    result, message = parse_as_mail(path)
    if result
      print '.'
      $stdout.flush
    else
      save_failure(path, message)
      print 'x'
    end
  end

  def save_failure(path, message)
    @failed_emails << [path, message]
    if @save_failures_to
      email_basename = File.basename(path)
      failure_as_filename = message.gsub(/\W/, '_')
      new_email_name = [failure_as_filename, email_basename].join("_")
      File.open(File.join(@save_failures_to, new_email_name), 'w+') do |fh|
        fh << File.read(path)
      end
    end
  end

  def parse_as_mail(path)
    @checked_count += 1
    begin
      _parsed_mail = Mail.read(path)
      [true, nil]
    rescue => e
      [false, e.message]
    end
  end

  def report_failures_to_stdout
    @failed_emails.each do |failed|
      puts "#{failed[0]} : #{failed[1]}"
    end
    puts "Failed: #{@failed_emails.size}"
  end

end
