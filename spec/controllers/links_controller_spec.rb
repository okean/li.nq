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
          flash[:error].should =~ /Validation failed/i
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
          flash[:success].should =~ /A short Url was created!/i
        end
      end
    end
  end
  
  describe "GET 'short_url'" do
    
    describe "failure" do
      
      it "should redirect to root path" do
        get :short_url, short_url: "invalid"
        response.should redirect_to root_path
      end
      
      it "should have a notification message" do
        get :short_url, short_url: "invalid"
        flash[:info].should =~ /I couldn't find a link for the URL you clicked./i
      end
    end
  
    describe "success" do
      before(:each) do
        @example_url = FactoryGirl.create(:example_url)
      end
      
      context "disable preview" do
        
        it "should redirect to target URL" do
          controller.disable_preview
          get :short_url, short_url: @example_url.link.identifier
          response.should redirect_to @example_url.original
        end
      end
      
      context "enable preview" do
        
        it "should render 'preview' page on first time preview" do
          get :short_url, short_url: @example_url.link.identifier
          response.should render_template('short_url')
        end
        
        it "should render 'preview' page if preview is enabled" do
          controller.enable_preview
          get :short_url, short_url: @example_url.link.identifier
          response.should render_template('short_url')
        end
      end
    end
  end
end