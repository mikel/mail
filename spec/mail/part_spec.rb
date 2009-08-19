require File.dirname(__FILE__) + '/../spec_helper'

require 'mail'

describe Mail::Part do
        
  it "should put content-ids into parts" do
    part = Mail::Part.new do
      body "This is Text"
    end
    part.to_s
    part.content_id.should_not be_nil
  end

end
