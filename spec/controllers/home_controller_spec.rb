require 'spec_helper'

describe HomeController do
  render_views

  describe "GET 'index'" do
    
    it "should be success" do
      get :index
      response.should be_success
    end
    
    it "should have the right title" do
      get :index
      response.should have_selector("title", content: "li.nq")
    end
  end
  
  describe "GET 'about'" do

    it "should be success" do
      get :about
      response.should be_success
    end
    
    it "should have the right title" do
      get :about
      response.should have_selector("title", content: "About")
    end
  end
end
