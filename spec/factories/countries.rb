FactoryBot.define do
  factory :united_kingdom, class: Shopr::Country do
    name        'United Kingdom'
    code2       'GB'
    code3       'GBR'
    continent   'EU'
    tld         'uk'
    currency    'GBP'
    eu_member   true
  end

  factory :united_states, class: Shopr::Country do
    name        'United States of America'
    code2       'US'
    code3       'USA'
    continent   'NA'
    tld         'us'
    currency    'USD'
    eu_member   false
  end

  factory :france, class: Shopr::Country do
    name        'France'
    code2       'FR'
    code3       'FRA'
    continent   'EU'
    tld         'fr'
    currency    'EUR'
    eu_member   true
  end
end
