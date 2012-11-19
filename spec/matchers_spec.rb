require 'spec_helper'

describe "have_sent_email" do
  include Mail::Matchers

  def send_test_email
    Mail.deliver do
      from    'phil@example.com'
      to      ['bob@example.com', 'fred@example.com']
      subject 'The facts you requested'
      body    'Here are the facts you requested. One-onethousand, two-onethousand.'
    end
  end

  before(:all) do
    $old_delivery_method = Mail.delivery_method

    Mail.defaults do
      delivery_method :test
    end
  end

  after(:all) do
    # Although this breaks encapsulation, it's the easiest way to ensure
    # that the delivery method is _exactly_ what it was before we started
    # messing with it.

    Mail::Configuration.instance.instance_variable_set(:@delivery_method, $old_delivery_method)
  end

  context "without any modifiers" do
    context "when no e-mail has been sent" do
      before(:each) do
        Mail::TestMailer.deliveries.clear
        Mail::TestMailer.deliveries.should be_empty
      end

      it { should_not have_sent_email }
    end

    context "when e-mail has been sent" do
      before(:each) do
        send_test_email
        Mail::TestMailer.deliveries.should_not be_empty
      end

      it { should have_sent_email }
    end
  end

  context "with #from" do
    context "and a matching sender" do
      it { should have_sent_email.from('phil@example.com') }
    end

    context "and a non-matching sender" do
      it { should_not have_sent_email.from('sven@example.com') }
    end
  end

  context "with #to" do
    context "and a matching recipient" do
      it { should have_sent_email.to('bob@example.com') }
      it { should have_sent_email.to('fred@example.com') }
      it { should have_sent_email.to('bob@example.com').to('fred@example.com') }
      it { should have_sent_email.to(['bob@example.com', 'fred@example.com']) }
    end

    context "and a non-matching recipient" do
      it { should_not have_sent_email.to('sven@example.com') }
    end
  end

  context "with #subject" do
    context "and a matching subject" do
      it { should have_sent_email.with_subject('The facts you requested') }
    end

    context "and a non-matching subject" do
      it { should_not have_sent_email.with_subject('facts you requested') }
      it { should_not have_sent_email.with_subject('the facts you') }
      it { should_not have_sent_email.with_subject('outright lies') }
    end
  end

  context "with #subject_matching" do
    context "and a matching subject" do
      it { should have_sent_email.matching_subject(/(facts|fiction) you requested/) }
    end

    context "and a non-matching subject" do
      it { should_not have_sent_email.matching_subject(/The \d+ facts you requested/) }
    end
  end

  context "with #with_body" do
    context "and a matching body" do
      it { should have_sent_email.with_body('Here are the facts you requested. One-onethousand, two-onethousand.') }
    end

    context "and a non-matching body" do
      it { should_not have_sent_email.with_body('Here are the facts you requested.') }
      it { should_not have_sent_email.with_body('are the facts you requested. One-onethousand') }
      it { should_not have_sent_email.with_body('Be kind to your web-footed friends, for a duck may be somebody\'s mother') }
    end
  end

  context "with #matching_body" do
    context "and a matching body" do
      it { should have_sent_email.matching_body(/one-?one(hundred|thousand)/i) }
    end

    context "and a non-matching body" do
      it { should_not have_sent_email.matching_body(/\d+-onethousand/) }
    end
  end

  context "with a huge chain of modifiers" do
    it do
      should have_sent_email.
             from('phil@example.com').
             to('bob@example.com').
             to('fred@example.com').
             with_subject('The facts you requested').
             matching_subject(/facts (I|you)/).
             with_body('Here are the facts you requested. One-onethousand, two-onethousand.').
             matching_body(/(I|you) request/)
    end
  end
end
