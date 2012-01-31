module EmailSanitizer
  class Observer
    def self.delivered_email(mail)
      mail.to = EmailSanitizer.unsanitize(mail.to)
    end
  end
end