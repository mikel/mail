Given /^a basic email in a string$/ do
  @string = "To: mikel\nFrom: bob\nSubject: Hello!\n\nemail message\n"
end

When /^I parse the basic email$/ do
  @mail = Mail.new(@string)
end

Then /^the '(.+)' field should be '(.+)'$/ do |attribute, value|
  @mail.send(attribute).should == value
end
