Gem::Specification.new do |s|
  s.name = 'sequence_on'
  s.version = SequenceOn::VERSION
  s.date = '2021-04-05'
  s.summary = 'Flexible acts_as_sequenced replacement'
  s.description = 'Flexible acts_as_sequenced replacement'
  s.authors = ['Jeremy SEBAN', 'Antonis Tzorvas']
  s.email = 'tech@qonto.eu'
  s.files = Dir['lib/**/*']
  s.license = 'MIT'
  s.homepage = 'https://github.com/qonto/sequence_on'
  s.required_ruby_version = '>= 2.3'

  s.add_dependency "activesupport", ">= 3.0"
  s.add_dependency "activerecord", ">= 3.0"
  s.add_development_dependency "rails", ">= 3.1"
end
