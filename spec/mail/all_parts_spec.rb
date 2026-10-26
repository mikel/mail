# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Mail::Message do
  describe "#all_parts" do
    it "should return parts in pre-order with nested multiparts flattened" do
      mail = Mail.new do
        content_type 'multipart/mixed; boundary="X"'
        part(content_type: 'multipart/alternative; boundary="Y"') do |alt|
          alt.text_part = Mail::Part.new { body 'hi' }
          alt.html_part = Mail::Part.new { content_type 'text/html'; body '<p>hi</p>' }
        end
        add_file filename: 'a.txt', content: 'data'
      end

      types = mail.all_parts.map { |p| p.content_type.split(';').first }
      expect(types).to eq([
        'multipart/alternative',
        'text/plain',
        'text/html',
        'text/plain',
      ])
    end

    it "should walk a deeply nested multipart message without raising" do
      raw = "Content-Type: text/plain\r\n\r\nhello\r\n"
      1000.times do |i|
        b = "b#{i}"
        raw = "Content-Type: multipart/mixed; boundary=\"#{b}\"\r\n\r\n--#{b}\r\n#{raw}--#{b}--\r\n"
      end
      raw = "From: a@example.com\r\nTo: b@example.com\r\nSubject: deep\r\n#{raw}"

      expect { Mail.new(raw).all_parts }.not_to raise_error
    end
  end
end
