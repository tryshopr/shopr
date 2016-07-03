module Shopr
  FactoryGirl.define do
    factory :user, class: User do
      first_name              'Someone'
      last_name               'Something'
      email                   'someone@something.com'
      password                'password'
      password_confirmation   'password'
    end
  end
end
