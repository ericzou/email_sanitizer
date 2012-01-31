require 'spec_helper'

describe EmailSanitizer::Observer do 
  describe "#delivered_email" do 
    it "should unsanitize email.to field" do 
      email = Mail.new(:to => ["test+foo_at_bar.com@bexample.com"])
      EmailSanitizer::Observer.delivered_email(email)
      email.to.should == EmailSanitizer.unsanitize(email.to)
    end
  end
end