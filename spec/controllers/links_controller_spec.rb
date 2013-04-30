require 'spec_helper'

describe LinksController do
  render_views

  describe "POST 'create'" do
    
    describe "failure" do

      it "should not create a short link" do
        lambda do
          post :create, custom: "", original: ""
        end.should_not change(Link, :count)
      end
      
      describe "Ajax" do
        it "should render index page" do
          xhr :post, :create, custom: "", original: ""
          response.should render_template('links/create')
        end
      end
      
      describe "HTTP" do        
        it "should render index page" do
          post :create, custom: "", original: ""
          response.should render_template('home/index')
        end
        
        it "should display an error message" do
          post :create, custom: "", original: ""
          response.should have_selector("div", class: "alert alert-error",
                                               content: "Validation failed")
        end
      end
    end
    
    describe "success" do
      
      before(:each) do
        @url = "http://example.iana.org/"
        @custom = "example"
      end
      
      it "should create short link" do
        lambda do
          post :create, custom: @custom, original: @url
        end.should change(Link, :count).by(1)
      end
      
      describe "Ajax" do        
        it "should render index page" do
          xhr :post, :create, custom: @custom, original: @url
          response.should render_template('links/create')
        end
      end
      
      describe "HTTP" do        
        it "should render index page" do
          post :create, custom: @custom, original: @url
          response.should render_template('home/index')
        end
        
        it "should display a success message" do
          post :create, custom: @custom, original: @url
          response.should have_selector("div", class: "alert alert-success",
                                               content: "A short Url was created!")
        end
      end
    end
  end
end