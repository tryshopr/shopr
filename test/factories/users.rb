module Shoppe
  FactoryGirl.define do
    
    factory :user, :class => User do
      first_name              'Adam'
      last_name               'Cooke'
      email_address           'adam@niftyware.io'
      password                'llamafarm'
      password_confirmation   'llamafarm'
    end
  
  end
end
