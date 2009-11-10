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
  # The methods you can call in the default configuration are:
  # 
  # smtp(server_name, port):: Sets the SMTP server domain name and port
  # pop3(server_name, port):: Sets the POP3 server domain name and port
  # user(username):: Sets the username used for POP3 sessions
  # pass(password):: Sets the password used for POP3 sessions
  #
  #  Mail.defaults do
  #    smtp 'smtp.myhost.fr', 587
  #    pop3 'pop.myhost.fr'
  #    user 'bernardo'
  #    pass 'mypass'
  #    enable_tls
  #  end
  # 
  # Once you have set defaults, you can call Mail.deliver to send an email
  # through the Mail.deliver method.
  def Mail.defaults(&block)
    if block_given?
      Mail::Configuration.instance.defaults(&block)
    end
  end

  # Send an email using the default configuration.  You do need to set a default
  # configuration first before you use Mail.deliver, if you don't, an appropriate
  # error will be raised telling you to.
  # 
  #  Mail.deliver do
  #   to 'mikel@test.lindsaar.net'
  #   from 'ada@test.lindsaar.net'
  #   subject 'This is a test email'
  #   body 'Not much to say here'
  #  end
  # 
  # And your email object will be created and sent.
  
  def Mail.deliver(*args, &block)
    Mail.new(args, &block).deliver!
  end

  def Mail.get_all_mail(&block)
    Mail::Message.get_all_mail(&block)
  end

  def Mail.read(filename)
    Mail.new(File.read(filename))
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