Gem::Specification.new do |s|
  s.name = 'email_sanitizer'
  s.version = '0.0.1'
  s.summary = "Email Sanitizer lets you avoid accidentally sending out emails to your customers from staging, demo or other non-production environments"
  s.description = "Email Sanitizer lets you avoid accidentally sending out emails to your customers from staging, demo or other non-production environments"
  s.authors = ['Eric Zou']
  s.email = 'hello@ericzou.com'
  s.homepage = 'https://github.com/ericzou/email_sanitizer'
  s.files = Dir['LICENSE', 'README.md', 'lib/**/*', 'spec/**/*']
  s.add_development_dependency 'rspec-rails', '>=2.0.0'
  s.add_development_dependency 'autotest', "~> 4.4.6"
  s.add_runtime_dependency 'actionmailer', '>=3.0.0'
end