require "bundler/gem_tasks"

task default: :test
task :test do
  Dir.glob("./test/*_test.rb").each { |file| require file }
  Dir.glob("./test/integration/*_test.rb").each { |file| require file }
end
