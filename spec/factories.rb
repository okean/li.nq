FactoryGirl.define do
  factory :link do
    identifier "lfls"
  end
  
  factory :url do
    original "http://www.iana.org/domains/example"
    link_id nil
  end
  
  factory :visit_data, class: Visit do
    ip "192.168.1.1"
    country "XX"
    link_id nil
  end
  
  factory :example_url, class: Url do
    original "http://www.iana.org/domains/example"
    link
  end
end