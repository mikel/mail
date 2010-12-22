module Net
  class SMTP
    remove_method :tlsconnect

    def tlsconnect(s)
      verified = false
      s = OpenSSL::SSL::SSLSocket.new s, @ssl_context
      logging "TLS connection started"
      s.sync_close = true
      s.connect
      if @ssl_context.verify_mode != OpenSSL::SSL::VERIFY_NONE
        s.post_connection_check(@address)
      end
      verified = true
      s
    ensure
      s.close unless verified
    end
  end
end
