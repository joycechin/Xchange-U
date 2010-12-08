# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Student"
  user.email                 "student@college.harvard.edu"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@college.harvard.edu"
end

Factory.define :academic do |academic|
  academic.content "Foo bar"
  academic.association :user
end