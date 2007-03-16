# $Id$
require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'

Rake::TestTask.new do |t|
  t.test_files = FileList[ 'test/test*.rb' ]
  t.verbose = true
end

namespace :test do
  desc 'Measures test coverage'
  task :coverage do
    rm_f "coverage"
    rm_f "coverage.data"
    rcov = "rcov --aggregate coverage.data --text-summary -Ilib"
    system("#{rcov} --html test/test*.rb")
    system("open coverage/index.html") if PLATFORM['darwin']
  end
  
  desc 'Heckle the tests'
  task :heckle do
    system("heckle HL7::Message")
  end
end


Rake::RDocTask.new do |rd|
  rd.main = "README"
  rd.rdoc_files.include("README", "LICENSE", "lib/**/*.rb")
end

spec = Gem::Specification.new do |s| 
  s.name = "Ruby-HL7"
  s.version = "0.1.0"
  s.author = "Mark Guzman"
  s.email = "segfault@hasno.info"
  s.homepage = "http://hasno.info"
  s.platform = Gem::Platform::RUBY
  s.summary = "Ruby HL7 Library"
  s.files = FileList["{bin,lib,test_data}/**/*"].to_a
  s.require_path = "lib"
  s.autorequire = "ruby-hl7"
  s.test_files = FileList["{test}/**/test*.rb"].to_a
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
  s.add_dependency("facets", ">= 0.0.0")
end
 
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_tar = true 
end 
