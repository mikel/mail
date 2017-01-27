# frozen_string_literal: true
require 'spec_helper'

describe "have_sent_email" do
  include Mail::Matchers

  let(:test_mail) do
    mail = Mail.new(
      :from    =>  'phil@example.com',
      :to      =>  ['bob@example.com', 'fred@example.com'],
      :cc      =>  ['dad@example.com', 'mom@example.com'],
      :bcc     =>  ['alice@example.com', 'sue@example.com'],
      :subject => 'The facts you requested',
      :body    => 'Here are the facts you requested. One-onethousand, two-onethousand.'
    )
    if include_attachments
      mail.attachments['myfile.pdf'] =   { :mime_type => 'application/x-pdf',
                                          :content   => 'test content' }
      mail.attachments['yourfile.csv'] = { :mime_type => 'application/csv',
                                           :content   => '1,2,3' }
    end
    mail
  end

  let(:include_attachments) { true }

  before(:all) do
    $old_delivery_method = Mail.delivery_method

    Mail.defaults do
      delivery_method :test
    end
  end

  before(:each) do
    Mail::TestMailer.deliveries.clear
    test_mail.deliver
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
        expect(Mail::TestMailer.deliveries).to be_empty
      end

      it { is_expected.not_to have_sent_email }
    end

    context "when e-mail has been sent" do
      before(:each) do
        expect(Mail::TestMailer.deliveries).not_to be_empty
      end

      it { is_expected.to have_sent_email }
    end
  end

  context "with #from" do
    context "and a matching sender" do
      it { is_expected.to have_sent_email.from('phil@example.com') }
    end

    context "and a non-matching sender" do
      it { is_expected.not_to have_sent_email.from('sven@example.com') }
    end
  end

  context "with #to" do
    context "and a matching recipient" do
      it { is_expected.to have_sent_email.to('bob@example.com') }
      it { is_expected.to have_sent_email.to('fred@example.com') }
      it { is_expected.to have_sent_email.to('bob@example.com').to('fred@example.com') }
      it { is_expected.to have_sent_email.to(['bob@example.com', 'fred@example.com']) }
    end

    context "and a non-matching recipient" do
      it { is_expected.not_to have_sent_email.to('sven@example.com') }
    end
  end

  context "with #cc" do
    context "and a matching recipient" do
      it { is_expected.to have_sent_email.cc('mom@example.com') }
      it { is_expected.to have_sent_email.cc('dad@example.com') }
      it { is_expected.to have_sent_email.cc('mom@example.com').cc('dad@example.com') }
      it { is_expected.to have_sent_email.cc(['mom@example.com', 'dad@example.com']) }
    end

    context "and a non-matching recipient" do
      it { is_expected.not_to have_sent_email.cc('granny@example.com') }
    end
  end

  context "with #bcc" do
    context "and a matching recipient" do
      it { is_expected.to have_sent_email.bcc('alice@example.com') }
      it { is_expected.to have_sent_email.bcc('sue@example.com') }
      it { is_expected.to have_sent_email.bcc('alice@example.com').bcc('sue@example.com') }
      it { is_expected.to have_sent_email.bcc(['alice@example.com', 'sue@example.com']) }
    end

    context "and a non-matching recipient" do
      it { is_expected.not_to have_sent_email.bcc('mario@example.com') }
    end
  end

  context "with #subject" do
    context "and a matching subject" do
      it { is_expected.to have_sent_email.with_subject('The facts you requested') }
    end

    context "and a non-matching subject" do
      it { is_expected.not_to have_sent_email.with_subject('facts you requested') }
      it { is_expected.not_to have_sent_email.with_subject('the facts you') }
      it { is_expected.not_to have_sent_email.with_subject('outright lies') }
    end
  end

  context "with #subject_matching" do
    context "and a matching subject" do
      it { is_expected.to have_sent_email.matching_subject(/(facts|fiction) you requested/) }
    end

    context "and a non-matching subject" do
      it { is_expected.not_to have_sent_email.matching_subject(/The \d+ facts you requested/) }
    end
  end

  context "with #with_body" do
    context "and a matching body" do
      it { is_expected.to have_sent_email.with_body('Here are the facts you requested. One-onethousand, two-onethousand.') }
    end

    context "and a non-matching body" do
      it { is_expected.not_to have_sent_email.with_body('Here are the facts you requested.') }
      it { is_expected.not_to have_sent_email.with_body('are the facts you requested. One-onethousand') }
      it { is_expected.not_to have_sent_email.with_body('Be kind to your web-footed friends, for a duck may be somebody\'s mother') }
    end
  end

  context 'with #with_attachments' do
    let(:first_attachment) { test_mail.attachments.first }
    let(:last_attachment) { test_mail.attachments.last }

    context 'and matching attachments' do

      context 'matching by filename' do
        it { is_expected.to have_sent_email.with_attachments(an_attachment_with_filename(first_attachment.filename)) }
      end

      context 'single attachment passed' do
        it { is_expected.to have_sent_email.with_attachments(first_attachment) }
      end

      context 'array of attachments passed' do
        it {is_expected.to have_sent_email.with_attachments([first_attachment, last_attachment]) }
      end

      context 'any_attachment passed' do
        it {is_expected.to have_sent_email.with_attachments([any_attachment]) }
      end

      context 'chaining attachment matching' do
        it { is_expected.to have_sent_email.with_attachments(first_attachment).with_attachments([last_attachment]) }
      end

      context 'ce matching' do
        it { is_expected.to have_sent_email.with_attachments(first_attachment).with_attachments([last_attachment]) }
      end

      context 'attachment order is important' do
        it {is_expected.to have_sent_email.with_attachments([first_attachment, last_attachment]) }
        it {is_expected.to_not have_sent_email.with_attachments([last_attachment, first_attachment]) }
      end
    end

    context 'and non-matching attachments' do
      it { is_expected.not_to have_sent_email.with_attachments('no_match') }
      it { is_expected.not_to have_sent_email.with_attachments(an_attachment_with_filename('no_match')) }
    end

    context 'and any attachments' do
      it { is_expected.to have_sent_email.with_any_attachments }
    end

    context 'and no attachments' do
      let(:include_attachments) { false }
      it { is_expected.to have_sent_email.with_no_attachments }
    end
  end

  context "with #matching_body" do
    context "and a matching body" do
      it { is_expected.to have_sent_email.matching_body(/one-?one(hundred|thousand)/i) }
    end

    context "and a non-matching body" do
      it { is_expected.not_to have_sent_email.matching_body(/\d+-onethousand/) }
    end
  end

  context "with a huge chain of modifiers" do
    it do
      is_expected.to have_sent_email.
             from('phil@example.com').
             to('bob@example.com').
             to('fred@example.com').
             with_subject('The facts you requested').
             with_attachments(test_mail.attachments.first).
             matching_subject(/facts (I|you)/).
             with_body('Here are the facts you requested. One-onethousand, two-onethousand.').
             matching_body(/(I|you) request/).
             with_any_attachments
    end
  end
end
