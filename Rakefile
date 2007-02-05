# $Id$
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

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

end

