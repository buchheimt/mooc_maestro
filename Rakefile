ENV["SINATRA_ENV"] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'

task :console do
  Pry.start
end

task :reload do
  File.delete('db/development.sqlite', 'db/schema.rb')
  Rake::Task["db:migrate"].invoke
  Rake::Task["db:seed"].invoke
end

task :create_db do
  Rake::Task["db:migrate"].invoke
  Rake::Task["db:seed"].invoke
end
