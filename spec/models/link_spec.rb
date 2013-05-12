require 'spec_helper'

describe Link do
  
  before(:each) do
    @attr = { identifier: "lfls" }
  end
  
  it "should create a link given valid attributes" do
    Link.create!(@attr).should be_valid
  end
  
  it "should require an identifier" do
    Link.new(@attr.merge(identifier: "")).should_not be_valid
  end
  
  it "should reject duplicate identifiers" do
    upcase_identifier = @attr[:identifier].upcase
    Link.create!(@attr)
    Link.new(@attr.merge(identifier: upcase_identifier)).should_not be_valid
  end
  
  it "should reject a profane identifier" do
    Link.new(@attr.merge(identifier: "ass")).should_not be_valid
  end
  
  it "should have an url attribute" do
    Link.new(@attr).should respond_to(:url)
  end
  
  it "should have a visits attribute" do
    Link.new(@attr).should respond_to(:visits)
  end
  
  describe "shorten method" do
    
    before(:each) do
      @url = "http://www.iana.org/domains/example"
    end
    
    it "should return the link if it is already defined" do
      link = Link.create!(@attr)
      url = FactoryGirl.create(:url, link_id: link.id)
      lambda do
        Link.shorten(url.original).should == link
      end.should_not change(Link, :count).by(1)
    end
    
    it "should create a custom link" do
      lambda do
        custom_link = "custom link"
        link = Link.shorten(@url, custom_link)
        link.identifier.should == custom_link
      end.should change(Link, :count).by(1)
    end
    
    it "should create a link using id identifier" do
      lambda do
        link = Link.shorten(@url)
        link.identifier.should == link.url.id.to_s(36)
      end.should change(Link, :count).by(1)
    end
  end
  
  describe "Url associations" do
    
    it "should destroy related url" do
      link = FactoryGirl.create(:link)
      url = FactoryGirl.create(:url, link_id: link.id)
      link.destroy
      Url.find_by_id(url.id).should be_nil
    end
  end
  
  describe "Visits associations" do
    
    it "should destroy related visit stats" do
      stub_ip_api
      link = FactoryGirl.create(:link)
      visit = FactoryGirl.create(:visit_data, link_id: link.id)
      link.destroy
      Visit.find_by_id(visit.id).should be_nil
    end
  end
end