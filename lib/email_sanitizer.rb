module EmailSanitizer
  class << self
    attr_accessor :base_email 
    def base_email
      @base_email ||= "default@example.com"
    end

    def base_local
      base_email.split('@').first
    end

    def base_domain
      base_email.split('@').last
    end

    def sanitize(email_addresses)
      email_addresses = normalize_email_addresses(email_addresses)
      email_addresses.inject([]) { |arry, address| arry << do_sanitize(address) }
    end

    private

    def normalize_email_addresses(email_addresses)
      return email_addresses.split(/[,;\s]+/) if email_addresses.class == String
      email_addresses 
    end

    def do_sanitize(email_address)
      local, domain = email_address.split('@')
      "#{base_local}+#{local}_at_#{domain}@#{base_domain}"
    end
  end
end

require 'email_sanitizer/interceptor'
Mail.register_interceptor(EmailSanitizer::Interceptor)