require 'spec_helper'

describe "When required" do 
  it "should register itself through Mail.register_interceptor" do 
    require 'email_sanitizer'
    Mail.class_variable_get(:@@delivery_interceptors).should include(EmailSanitizer::Interceptor)
  end
end

require 'email_sanitizer'

describe EmailSanitizer do 

  describe "#base_email" do 
    it "should default to default@example.com" do 
      EmailSanitizer.base_email.should == "default@example.com"
    end

    it "should be changeable" do 
      EmailSanitizer.base_email = "test@example.com"
      EmailSanitizer.base_email.should == "test@example.com"
    end
  end

  describe '#sanitize' do 
    it 'should modify a email with correct format' do 
      EmailSanitizer.base_email = 'default@example.com'
      email = "foo@bar.com"
      EmailSanitizer.sanitize(email).should == ['default+foo_at_bar.com@example.com']
    end

    it 'should be able to take a string of email addresses' do 
      EmailSanitizer.base_email = 'default@example.com'
      [ "foo@bar.com, test@bar.com, abc@example.com", "foo@bar.com test@bar.com abc@example.com", "foo@bar.com; test@bar.com; abc@example.com"].each do |s|
        EmailSanitizer.sanitize(s).should == ["default+foo_at_bar.com@example.com", "default+test_at_bar.com@example.com", "default+abc_at_example.com@example.com"]  
      end      
    end

    it "should be able to take an array of email addresses" do 
      EmailSanitizer.base_email = 'default@example.com'
      EmailSanitizer.sanitize(["foo@bar.com", "abc@example.com"]).should == ["default+foo_at_bar.com@example.com", 'default+abc_at_example.com@example.com']
    end
  end

  it "should work as advertised" do 
    ActionMailer::Base.delivery_method = :test
    EmailSanitizer.base_email = "default@example.com"
    email = TestMailer.notification
    email.to.should == ["foo@bar.com"]
    email.deliver
    email.to.should == ["default+foo_at_bar.com@example.com"]
  end
  
end

