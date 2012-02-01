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

    it "should be able to handle email such as 'support+foo@bar.com'" do 
      EmailSanitizer.base_email = 'default@example.com'
      EmailSanitizer.sanitize(["support+foo@bar.com"]).should == ["default+support+foo_at_bar.com@example.com"]
    end
  end

  describe "#sanitized?" do 
    it "should return true " do 
      EmailSanitizer.base_email = "test@example.com"
      EmailSanitizer.send(:sanitized?, "test+foo_at_bar.com@example.com").should be_true
    end

    it "should return false " do 
      EmailSanitizer.base_email = "test@example.com"
      EmailSanitizer.send(:sanitized?, "foo@bar.com").should be_false
      EmailSanitizer.send(:sanitized?, "foo+test.com@bar.com").should be_false
    end

    it "should support '+' format" do 
      EmailSanitizer.base_email = "support+test@example.com"
      EmailSanitizer.send(:sanitized?, "support+test+foo_at_bar.com@example.com").should be_true
    end
  end

  describe "#unsanitize" do 
    it "should undo sanitize" do 
      EmailSanitizer.base_email = "test@example.com"
      EmailSanitizer.unsanitize("test+foo_at_bar.com@example.com").should == ['foo@bar.com']
    end

    it "should support '+' format" do 
      EmailSanitizer.base_email = "support+test@example.com"
      EmailSanitizer.unsanitize("support+test+foo_at_bar.com@example.com").should == ['foo@bar.com']
    end

  end

  describe "usage" do 
    before(:each) do 
      ActionMailer::Base.delivery_method = :test
      EmailSanitizer.base_email = "default@example.com"
      @email = TestMailer.notification
      @email.to.should == ["foo@bar.com"]
    end

    it "should not change email addresses after deliver" do
      b = @email.to
      @email.deliver
      @email.to.should == b
    end
    
  end
  
end

