require 'spec_helper'
require 'email_sanitizer'

describe EmailSanitizer::Interceptor do 
  describe "#delivering_email" do 
    it "should sanitize 'to' field on email" do
      email_address = "foo@bar.com"
      email = Mail.new(:to => email_address)
      EmailSanitizer::Interceptor.delivering_email(email)
      email.to.should == EmailSanitizer.sanitize(email_address)
    end
  end
end