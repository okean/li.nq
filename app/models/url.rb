class Url < ActiveRecord::Base
  attr_accessible :link_id, :original
  
  belongs_to :link
  
  validates :original, presence: true
end
