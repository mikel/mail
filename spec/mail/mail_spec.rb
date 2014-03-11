# encoding: utf-8 
require 'spec_helper'

describe "mail" do
  
  it "should be able to be instantiated" do
    doing { Mail }.should_not raise_error
  end
  
  it "should be able to make a new email" do
    Mail.new.class.should eq Mail::Message
  end
  
  it "should accept headers and body" do
    # Full tests in Message Spec
    message = Mail.new do
      from    'mikel@me.com'
      to      'mikel@you.com'
      subject 'Hello there Mikel'
      body    'This is a body of text'
    end
    message.from.should      eq ['mikel@me.com']
    message.to.should        eq ['mikel@you.com']
    message.subject.should   eq 'Hello there Mikel'
    message.body.to_s.should eq 'This is a body of text'
  end

  it "should read a file" do
    wrap_method = Mail.read(fixture('emails', 'plain_emails', 'raw_email.eml')).to_s
    file_method = Mail.new(File.open(fixture('emails', 'plain_emails', 'raw_email.eml'), 'rb', &:read)).to_s
    wrap_method.should eq file_method
  end

  it "should load test environment connection details from yaml file" do
    filepath = File.expand_path(File.dirname(__FILE__) + "/mail_spec.yml")
    ENV['RACK_ENV'] = 'test'
    Mail.load!(filepath)
    Mail.delivery_method.class.should  eq Mail::TestMailer
    Mail.retriever_method.class.should eq Mail::TestRetriever
  end

  it "should load development connection details from yaml file" do
    filepath = File.expand_path(File.dirname(__FILE__) + "/mail_spec.yml")
    Mail.load!(filepath, 'development')
    retriever_settings = Mail.retriever_method.settings
    Mail.delivery_method.class.should      eq Mail::Exim
    Mail.retriever_method.class.should     eq Mail::POP3
    retriever_settings[:address].should    eq 'localhost'
    retriever_settings[:port].should       eq 995
    retriever_settings[:user_name].should  eq '<username>'
    retriever_settings[:password].should   eq '<password>'
    retriever_settings[:enable_ssl].should eq true
  end

  it "should load production connection details from yaml file" do
    filepath = File.expand_path(File.dirname(__FILE__) + "/mail_spec.yml")
    Mail.load!(filepath, 'production')
    delivery_settings  = Mail.delivery_method.settings
    retriever_settings = Mail.retriever_method.settings
    Mail.delivery_method.class.should               eq Mail::SMTP
    delivery_settings[:address].should              eq 'smtp.gmail.com'
    delivery_settings[:port].should                 eq 587
    delivery_settings[:domain].should               eq 'your.host.name'
    delivery_settings[:user_name].should            eq '<username>'
    delivery_settings[:password].should             eq '<password>'
    delivery_settings[:authentication].should       eq 'plain'
    delivery_settings[:enable_starttls_auto].should eq true
    Mail.retriever_method.class.should              eq Mail::POP3
    retriever_settings[:address].should             eq 'pop.gmail.com'
    retriever_settings[:port].should                eq 995
    retriever_settings[:user_name].should           eq '<username>'
    retriever_settings[:password].should            eq '<password>'
    retriever_settings[:enable_ssl].should          eq true
  end

end
