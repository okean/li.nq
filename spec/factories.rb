FactoryGirl.define do
  factory :link do
    identifier "lfls"
  end
  
  factory :url do
    original "http://www.iana.org/domains/example"
    link_id nil
  end
end