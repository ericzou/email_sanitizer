class TestMailer < ActionMailer::Base
  def notification
    mail(:to => "foo@bar.com", :from => "test@example.com")
  end
end