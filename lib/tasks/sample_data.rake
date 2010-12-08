require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_academics
    make_matchings
  end
end

def make_users
    admin = User.create!(:name => "Example User",
        :email => "example@college.harvard.edu",
        :password => "foobar",
        :password_confirmation => "foobar")
    admin.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@college.harvard.edu"
      password  = "password"
      User.create!(:name => name,
          :email => email,
          :password => password,
          :password_confirmation => password)
    end
  end
  
def make_academics
    User.all(:limit => 6).each do |user|
      50.times do
        user.academics.create!(:description => Faker::Lorem.sentence(2),
                               :learn => Faker::Lorem.words(1),
                               :teach => Faker::Lorem.words(1))
      end
    end
  end
  
def make_matchings
  users = User.all
  user  = users.first
  helping = users[1..50]
  helpers = users[3..40]
  helping.each { |helped| user.help!(helped) }
  helpers.each { |helper| helper.help!(user) }
end

