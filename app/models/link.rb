require 'obscenity/active_model'

class Link < ActiveRecord::Base
  attr_accessible :identifier

  has_one :url,     dependent: :destroy
  has_many :visits, dependent: :destroy 

  validates :identifier, presence: true,
                         uniqueness: { case_sensitive: false },
                         obscenity: true
  
  def self.shorten(original, custom=nil)
    url = Url.find_by_original(original)
    return url.link if url
    if custom
      link = Link.create!(identifier: custom)
      link.create_url!(original: original)
      link.save
    else
      link = create_link(original)
    end
    link
  end
  
  private
  
    def self.create_link(original)
      url = Url.create!(original: original)
      identifier = url.id.to_s(36)
      if Link.find_by_identifier(identifier).nil? or !Obscenity.profane?(original)
        link = Link.create!(identifier: identifier)
        link.url = url
        link.save
        link
      else
        create_link(original)
      end
    end
end
