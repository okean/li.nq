require 'json'

class Visit < ActiveRecord::Base
  attr_accessible :ip, :link_id
  
  belongs_to :link
  
  ip_regex = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
  
  validates :ip, presence: true,
                 format: { with: ip_regex, message: "should be a valid ip address" }
  
  before_save :set_country
  
  def self.total_grouped_by_day(start, identifier)
    time_range = start.beginning_of_day..Time.zone.now
    visits = Link.joins(:visits).
                  where(:identifier => identifier, :"visits.created_at" => time_range).
                  group("date(visits.created_at)").
                  select("visits.created_at, count(visits.ip) as total_visits").
                  order("visits.created_at")
    visits.group_by { |v| v.created_at.to_date }
  end
  
  def self.total_grouped_by_country(identifier)
    visits = Link.joins(:visits).
                  where(:identifier => identifier).
                  group("visits.country").
                  select("visits.country, count(visits.ip) as total_visits")
    visits.group_by { |v| v.country }
  end
  
  private
  
  def set_country
    response = HTTParty.get("http://ip-api.com/json/#{ip}")
    countryCode = JSON.parse(response.body)["countryCode"]
    self.country = (countryCode.nil? or countryCode.blank?) ? "XX" : countryCode
  end
end
