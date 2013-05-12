require 'spec_helper'

describe Visit do
  
  before(:each) do
    stub_ip_api
    @link = FactoryGirl.create(:link)
    @attr = { ip: "192.168.1.1" }
  end
  
  it "should create a visit object given valid attributes" do
    @link.visits.create!(@attr).should be_valid
  end
  
  it "should have a link attribute" do
    @link.visits.create!(@attr).should respond_to(:link)
  end
  
  it "should have a right country code" do
    visit = @link.visits.create(@attr.merge(ip: "88.51.132.237"))
    visit.country.should == "IT"
  end
  
  it "should require an ip address" do
    @link.visits.new(@attr.merge(ip: "")).should_not be_valid
  end
  
  it "should accept valid ip addresses" do
    ip_addresses = ["73.60.124.136", "88.51.132.237"]
    ip_addresses.each do |ip_address|
      @link.visits.new(@attr.merge(ip: ip_address)).should be_valid
    end
  end
  
  it "should reject ivalid ip addresses" do
    ip_addresses = ["256.60.124.136", "203.0.113.256"]
    ip_addresses.each do |ip_address|
      @link.visits.new(@attr.merge(ip: ip_address)).should_not be_valid
    end
  end
  
  it "should have a total_grouped_by_day method" do
    Visit.should respond_to(:total_grouped_by_day)
  end
  
  it "should have a total_grouped_by_country method" do
    Visit.should respond_to(:total_grouped_by_country)
  end
  
  describe "total_grouped_by_day" do
    
    before(:each) do
      @link.visits.create(@attr)
      @total_visits = Visit.total_grouped_by_day(1.week.ago, @link.identifier)
    end
    
    it "should return an object of Hash type" do
      @total_visits.class.should == Hash
    end
    
    it "should return the total number of visits" do
      @total_visits[@link.created_at.to_date].first.total_visits.should == 1
    end
  end
  
  describe "total_grouped_by_country" do
    
    before(:each) do
      @visit = @link.visits.create(@attr)
      @total_visits = Visit.total_grouped_by_country(@link.identifier)
    end
    
    it "should return an object of Hash type" do
      @total_visits.class.should == Hash
    end
    
    it "should return the total number of visits" do
      @total_visits[@visit.country].first.total_visits.should == 1
    end
  end
end
