require 'spec_helper'

describe LinksController do
  render_views

  describe "GET 'info'" do
    
    describe "failure" do
      
      it "should redirect to root path" do
        get :info, short_url: 1
        response.should redirect_to root_path
      end
      
      it "should have a right message" do
        get :info, short_url: 1
        flash[:info].should =~ /This link is not defined yet/i
      end
    end
    
    describe "success" do
      
      before(:each) do
        @url = FactoryGirl.create(:example_url)
      end
      
      it "should render info page" do
        get :info, short_url: @url.link.identifier
        response.should render_template('links/info')
      end
      
      it "should have 15 days as default number for bar chart" do
        get :info, short_url: @url.link.identifier
        assigns(:num_of_days).round.should == 15.days.ago.round
      end
      
      it "should use provided day number for bar chart" do
        get :info, short_url: @url.link.identifier, num_of_days: 7
        assigns(:num_of_days).round.should == 7.days.ago.round
      end
      
      it "should provide data for count days bar chart" do
        stub_ip_api
        visit = FactoryGirl.create(:visit_data, link_id: @url.link.id)
        date = 1.day.ago.to_date.to_time(:utc).to_i * 1000
        get :info, short_url: @url.link.identifier, num_of_days: 1
        assigns(:count_days_bar).first[0] == date
        assigns(:count_days_bar).first[1] == 1
      end
    end
  end

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