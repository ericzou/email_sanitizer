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

    def unsanitize(email_addresses)
      email_addresses = normalize_email_addresses(email_addresses)
      email_addresses.inject([]) { |arry, address| arry << do_unsanitize(address) }      
    end

    private

    def normalize_email_addresses(email_addresses)
      return email_addresses.split(/[,;\s]+/) if email_addresses.class == String
      email_addresses 
    end

    def sanitized?(email_address)
      email_address =~ /#{base_local}\+.+_at_.+@#{base_domain}/
    end

    def do_sanitize(email_address)
      local, domain = email_address.split('@')
      "#{base_local}+#{local}_at_#{domain}@#{base_domain}"
    end

    def do_unsanitize(email_address)
      return email_address unless sanitized?(email_address)
      address = email_address.split(/#{base_local}\+|@/)[1]
      address.sub('_at_', '@')
    end
  end
end

require 'mail'
require 'email_sanitizer/interceptor'
require 'email_sanitizer/observer'
Mail.register_interceptor(EmailSanitizer::Interceptor)
Mail.register_observer(EmailSanitizer::Observer)