$: << './lib'
require 'ruby-hl7'
require 'rake'
require 'rubyforge'

full_name = "Ruby-HL7"
short_name = full_name.downcase


Gem::Specification.new do |s| 
  s.name = short_name
  s.full_name
  s.version = HL7::VERSION
  s.author = "Mark Guzman"
  s.email = "segfault@hasno.info"
  s.homepage = "http://rubyforge.org/ruby-hl7"
  s.platform = Gem::Platform::RUBY
  s.summary = "Ruby HL7 Library"
  s.rubyforge_project = short_name
  s.description = "A simple library to parse and generate HL7 2.x messages"
  s.files = FileList["{bin,lib,test_data}/**/*"].to_a
  s.require_path = "lib"
  s.test_files = FileList["{test}/**/test*.rb"].to_a
  s.has_rdoc = true
  s.required_ruby_version = '>= 1.8.6'
  s.extra_rdoc_files = %w[README LICENSE]
  s.add_dependency("rake", ">= #{RAKEVERSION}")
  s.add_dependency("rubyforge", ">= #{::RubyForge::VERSION}")
end
