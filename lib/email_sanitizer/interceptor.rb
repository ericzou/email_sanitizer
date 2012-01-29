module EmailSanitizer
  class Interceptor
    def self.delivering_email(email)
      email.to = EmailSanitizer.sanitize(email.to)
    end
  end
end