FactoryBot.define do

  factory :valid_user, class: User do
    name { 'Test' }
    email { 'Test@123.com' }
    password { '123' }
  end

  factory :jelly_user, class: User do
    name { 'Jelly' }
    email { 'Jelly@fish.com' }
    password { 'fish' }
  end

end