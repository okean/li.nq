require 'uri'

class Url < ActiveRecord::Base
  attr_accessible :link_id, :original
  
  belongs_to :link

  uri_regex = URI::regexp
  
  validates :original, presence: true,
                       format: { with: uri_regex, message: "Only valid URLs is allowed" }
end
