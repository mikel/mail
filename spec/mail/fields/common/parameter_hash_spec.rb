require 'spec_helper'
require 'mail/fields/common/parameter_hash'

describe Mail::ParameterHash do
  it "should return the values in the hash" do
    hash = Mail::ParameterHash.new
    hash.merge!({'value1' => 'one', 'value2' => 'two'})
    hash.keys.should include("value1")
    hash.keys.should include("value2")
    hash.values.should include('one')
    hash.values.should include('two')
  end

  it "should return the values in the hash regardless of symbol or string" do
    hash = Mail::ParameterHash.new
    hash.merge!({'value1' => 'one', 'value2' => 'two'})
    hash['value1'].should eq 'one'
    hash['value2'].should eq 'two'
    hash[:value1].should eq 'one'
    hash[:value2].should eq 'two'
  end

  it "should return the values in the hash using case-insensitive key matching" do
    hash = Mail::ParameterHash.new
    hash.merge!({'value1' => 'one', 'VALUE2' => 'two'})
    hash['VALUE1'].should eq 'one'
    hash['vAlUe2'].should eq 'two'
    hash[:VaLuE1].should eq 'one'
    hash[:value2].should eq 'two'
  end

  it "should return the correct value if they are not encoded" do
    hash = Mail::ParameterHash.new
    hash.merge!({'value1' => 'one', 'value2' => 'two'})
    hash['value1'].should eq 'one'
    hash['value2'].should eq 'two'
  end

  it "should return a name list concatenated" do
    hash = Mail::ParameterHash.new
    hash.merge!({'value*1' => 'one', 'value*2' => 'two'})
    hash['value'].should eq 'onetwo'
  end

  it "should return a name list concatenated and unencoded" do
    hash = Mail::ParameterHash.new
    hash.merge!({'value*0*' => "us-ascii'en'This%20is%20even%20more%20",
                 'value*1*' => "%2A%2A%2Afun%2A%2A%2A%20",
                 'value*2'  => "isn't it"})
    hash['value'].should eq "This is even more ***fun*** isn't it"
  end

  it "should allow us to add a value" do
    hash = Mail::ParameterHash.new
    hash['value'] = 'bob'
    hash['value'].should eq 'bob'
  end

  it "should return an encoded value" do
    hash = Mail::ParameterHash.new
    hash.merge!({'value*0*' => "us-ascii'en'This%20is%20even%20more%20",
                 'value*1*' => "%2A%2A%2Afun%2A%2A%2A%20",
                 'value*2'  => "isn't it"})
    hash.encoded.should eq %Q{value*0*=us-ascii'en'This%20is%20even%20more%20;\r\n\svalue*1*=%2A%2A%2Afun%2A%2A%2A%20;\r\n\svalue*2="isn't it"}
  end

end
