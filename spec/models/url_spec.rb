require 'spec_helper'

describe Url do
  
  before(:each) do
    @link = FactoryGirl.create(:link)
    @attr = { original: "http://www.iana.org/domains/example/2" }
  end
  
  it "should create an url given valid attributes" do
    @link.create_url!(@attr).should be_valid
  end
  
  it "should have a link attribute" do
    @link.build_url(@attr).should respond_to(:link)
  end
  
  it "should require the original url" do
    @link.build_url(@attr.merge(original: "")).should_not be_valid
  end
  
  it "should reject invalid URIs" do
    invalid_uris = ["invalid", "htt", "://"]
    invalid_uris.each do |uri|
      @link.build_url(@attr.merge(original: uri)).should_not be_valid
    end
  end
  
  it "should accept valid URIs" do
    valid_uris = ["http://example.iana.org/", "https://example.iana.org/",
                  "http://example.iana.org:8088", "http://www.iana.org/domains/example"]
    valid_uris.each do |uri|
      @link.build_url(@attr.merge(original: uri)).should be_valid
    end
  end
end
