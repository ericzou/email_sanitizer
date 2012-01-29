Gem::Specification.new do |s|
  s.name = 'Email Sanitizer'
  s.version = '0.0.1'
  s.summary = "Email Sanitizor lets you avoid accidently sending out emails to your customers from staging, demo or other non-production environments"
  s.authors = ['Eric Zou']
  s.email = 'hello@ericzou.com'
  s.add_development_dependency 'rspec-rails', '>=2.0.0'
  s.add_development_dependency 'autotest', "~> 4.4.6"
  s.add_runtime_dependency 'actionmailer', '>=3.0.0'
end