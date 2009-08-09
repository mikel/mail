# encoding: utf-8

# = smtp_tls
# 
# * http://seattlerb.rubyforge.org/smtp_tls
# 
# == DESCRIPTION:
# 
# Provides SMTP STARTTLS support for Ruby 1.8.6 (built-in for 1.8.7+).  Simply
# require 'smtp_tls' and use the Net::SMTP#enable_starttls method to talk to
# servers that use STARTTLS.

require 'openssl'
require 'net/smtp'

# :stopdoc:

class Net::SMTP

  class SMTP_TLS
    VERSION = '1.0.3'
  end

  class << self
    send :remove_method, :start
  end

  def self.default_ssl_context
    OpenSSL::SSL::SSLContext.new
  end

  def self.start(address, port = nil, helo = 'localhost.localdomain',
                 user = nil, secret = nil, authtype = nil, &block) # :yield: smtp
    smtp = new address, port
    smtp.start helo, user, secret, authtype, &block
  end

  def enable_starttls(context = Net::SMTP.default_ssl_context)
    raise 'openssl library not installed' unless defined?(OpenSSL)
    @starttls = :always
    @ssl_context = context
  end

  alias tls_old_start start

  def start(helo = 'localhost.localdomain',
            user = nil, secret = nil, authtype = nil) # :yield: smtp
    start_method = @starttls ? :do_tls_start : :do_start

    if block_given?
      begin
        send start_method, helo, user, secret, authtype
        return yield(self)
      ensure
        do_finish
      end
    else
      send start_method, helo, user, secret, authtype
      return self
    end
  end

  def starttls
    getok 'STARTTLS'
  end

  alias tls_old_quit quit # :nodoc:

  def quit
    begin
      getok 'QUIT'
    rescue EOFError
    end
  end

  private

  def do_tls_start(helodomain, user, secret, authtype)
    raise IOError, 'SMTP session already started' if @started
    check_auth_args user, secret, authtype if user or secret

    sock = timeout(@open_timeout) { TCPSocket.open @address, @port }
    @socket = Net::InternetMessageIO.new(sock)
    @socket.debug_output = @debug_output
    @socket.read_timeout = 60 # @read_timeout

    check_response(critical { recv_response() })
    do_helo helodomain

    raise 'openssl library not installed' unless defined?(OpenSSL)
    starttls
    @ssl_context.tmp_dh_callback = proc { }
    ssl = OpenSSL::SSL::SSLSocket.new sock, @ssl_context
    @debug_output << "TLS connection started\n" if @debug_output
    ssl.sync_close = true
    ssl.connect
    if @ssl_context.verify_mode != OpenSSL::SSL::VERIFY_NONE then
      ssl.post_connection_check(@address)
    end

    @socket = Net::InternetMessageIO.new ssl
    @socket.debug_output = @debug_output
    @socket.read_timeout = 60 # @read_timeout
    do_helo helodomain

    authenticate user, secret, authtype if user
    @started = true
  ensure
    unless @started then
      # authentication failed, cancel connection.
      @socket.close if not @started and @socket and not @socket.closed?
      @socket = nil
    end
  end

  def do_helo(helodomain)
    begin
      if @esmtp then
        ehlo helodomain
      else
        helo helodomain
      end
    rescue Net::ProtocolError
      if @esmtp then
        @esmtp = false
        @error_occured = false
        retry
      end
      raise
    end
  end

end unless Net::SMTP.method_defined? :starttls

