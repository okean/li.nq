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
end
