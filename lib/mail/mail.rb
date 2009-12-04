# encoding: utf-8
module Mail
  
  # Allows you to create a new Mail::Message object.
  # 
  # You can make an email via passing a string or passing a block.
  # 
  # For example, the following two examples will create the same email
  # message:
  # 
  # Creating via a string:
  # 
  #  string = 'To: mikel@test.lindsaar.net\r\n'
  #  string << 'From: bob@test.lindsaar.net\r\n\r\n'
  #  string << 'Subject: This is an email\r\n'
  #  string << '\r\n'
  #  string << 'This is the body'
  #  Mail.new(string)
  # 
  # Or creating via a block:
  # 
  #  message = Mail.new do
  #    to 'mikel@test.lindsaar.net'
  #    from 'bob@test.lindsaar.net'
  #    subject 'This is an email'
  #    body 'This is the body'
  #  end
  # 
  # Or creating via a hash (or hash like object):
  # 
  #  message = Mail.new({:to => 'mikel@test.lindsaar.net',
  #                      'from' => 'bob@test.lindsaar.net',
  #                       :subject 'This is an email',
  #                       :body 'This is the body' })
  # 
  # Note, the hash keys can be strings or symbols, the passed in object
  # does not need to be a hash, it just needs to respond to :each_pair
  # and yield each key value pair.
  # 
  # As a side note, you can also create a new email through creating
  # a Mail::Message object directly and then passing in values via string,
  # symbol or direct method calls.  See Mail::Message for more information.
  # 
  #  mail = Mail.new
  #  mail.to = 'mikel@test.lindsaar.net'
  #  mail[:from] = 'bob@test.lindsaar.net'
  #  mail['subject'] = 'This is an email'
  #  mail.body = 'This is the body'
  def Mail.new(*args, &block)
    Mail::Message.new(args, &block)
  end

  # Set the default configuration to send and receive emails.  The defaults
  # are global, allowing you to just call them once and use them everywhere.
  # if port values are omitted from the SMTP and POP3 method calls, then it
  # is assumed to use the default ports of 25 and 110 respectively.
  # 
  # You call defaults in a block, then you can set the basic host and port,
  # by passing arguments, also, if the method you are using required more
  # information (like pop3), then pass a block to it and call methods like
  # user, pass, enable_tls etc.
  # 
  # The arguments and block are both optional.
  #
  #  Mail.defaults do
  #    smtp 'smtp.myhost.fr', 587
  #    pop3 'pop.myhost.fr' do
  #      user 'bernardo'
  #      pass 'mypass'
  #      enable_tls
  #    end
  #  end
  # 
  # You will also want to specify a delivery and retriever type, the defaults
  # are SMTP and POP3.  You set the types by passing a symbol:
  # 
  #  Mail.defaults do
  #    retriever_method :pop3
  #    delivery_method :smtp
  #  end
  # 
  # The only implemented methods at the moment are :pop3, :smtp and :test
  # 
  # You can also specify your own delivery class which must respond to :deliver!
  # or a retriever class which must respond to :get_messages
  # 
  #  Mail.defaults do
  #    retriever_method MyOwnRetriever.new
  #  end
  # 
  # Once you have set defaults, you can call Mail.deliver to send an email
  # through the Mail.deliver method.
  def Mail.defaults(&block)
    if block_given?
      Mail::Configuration.instance.defaults(&block)
    else
      Mail::Configuration.instance
    end
  end

  # Send an email using the default configuration.  You do need to set a default
  # configuration first before you use Mail.deliver, if you don't, an appropriate
  # error will be raised telling you to.
  # 
  # If you do not specify a delivery type, SMTP will be used.
  # 
  #  Mail.deliver do
  #   to 'mikel@test.lindsaar.net'
  #   from 'ada@test.lindsaar.net'
  #   subject 'This is a test email'
  #   body 'Not much to say here'
  #  end
  # 
  # You can also do:
  # 
  #  mail = Mail.read('email.eml')
  #  mail.deliver!
  # 
  # And your email object will be created and sent.
  def Mail.deliver(*args, &block)
    mail = Mail.new(args, &block)
    Deliverable.perform_delivery!(mail)
    mail
  end

  # Receive the first email(s) from a Pop3 server.
  # See Mail::POP3 for a complete documentation.
  def Mail.first(*args, &block)
    Retrievable.first(*args, &block)
  end

  # Receive the first email(s) from a Pop3 server.
  # See Mail::POP3 for a complete documentation.
  def Mail.last(*args, &block)
    Retrievable.last(*args, &block)
  end

  # Receive all emails from a Pop3 server.
  # See Mail::POP3 for a complete documentation.
  def Mail.all(*args, &block)
    Retrievable.all(*args, &block)
  end

  # Receive all emails from a Pop3 server.
  # DEPRECATED: please use Mail.all instead.
  def Mail.get_all_mail(*args, &block)
    warn "Mail.get_all_mail is deprecated. Please use Mail.all instead."
    all(*args, &block)
  end

  # Find emails in a Pop3 server.
  # See Mail::POP3 for a complete documentation.
  def Mail.find(*args, &block)
    Retrievable.find(*args, &block)
  end

  def Mail.read(filename)
    Mail.new(File.read(filename))
  end

  # Provides a store of all the emails sent
  def Mail.deliveries
    @@deliveries ||= []
  end
  
  protected
  
  def Mail.random_tag
    t = Time.now
    sprintf('%x%x_%x%x%d%x',
            t.to_i, t.tv_usec,
            $$, Thread.current.object_id.abs, Mail.uniq, rand(255))
  end
  
  private

  def Mail.something_random
    (Thread.current.object_id * rand(255) / Time.now.to_f).to_s.slice(-3..-1).to_i
  end
  
  def Mail.uniq
    @@uniq += 1
  end
  
  @@uniq = Mail.something_random
  
end