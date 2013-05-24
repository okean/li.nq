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
        date = visit.created_at.to_date.to_time(:utc).to_i * 1000
        get :info, short_url: @url.link.identifier, num_of_days: 1
        assigns(:count_days_bar)[1][0].should == date
        assigns(:count_days_bar)[1][1].should == 1
      end
      
      it "should provide data for count country bar chart" do
        stub_ip_api
        visit = FactoryGirl.create(:visit_data, link_id: @url.link.id)
        date = 1.day.ago.to_date.to_time(:utc).to_i * 1000
        get :info, short_url: @url.link.identifier, num_of_days: 1
        assigns(:count_country_bar_countrycodes).first.should == visit.country
        assigns(:count_country_bar_visits).first.should == 1
      end
      
      it "should have a qr code image" do
        img_src = "https://chart.googleapis.com/chart?cht=qr&chs=150x150&chl=#{root_url + @url.link.identifier}"
        get :info, short_url: @url.link.identifier
        response.should have_selector("img", src: img_src)
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
      
      describe "JSON" do
        it "should have a flash message" do
          get :create, custom: "", original: "", format: :json
          flash[:error].should_not be_nil
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
      
      describe "JSON" do
        it "should render successfully" do
          get :create, custom: @custom, original: @url, format: :json
          response.should be_success
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
        stub_ip_api
        @example_url = FactoryGirl.create(:example_url)
      end
      
      it "should record the call as a visit" do
        lambda do
          get :short_url, short_url: @example_url.link.identifier
        end.should change(Visit, :count).by(1)
      end
      
      it "should have a qr code image" do
        img_src = "https://chart.googleapis.com/chart?cht=qr&chs=150x150&chl=#{root_url + @example_url.link.identifier}"
        get :short_url, short_url: @example_url.link.identifier
        response.should have_selector("img", src: img_src)
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
  
  describe "GET 'index'" do
    
    before(:each) do
      stub_ip_api
      @links = []
      3.times do
        @links << FactoryGirl.create(:link,
                                 identifier: FactoryGirl.generate(:identifier))
        url = FactoryGirl.create(:url, original: FactoryGirl.generate(:original),
                                 link_id: @links.last.id)
        rand(3).times do
          visit = FactoryGirl.create(:visit_data, link_id: @links.last.id)
        end
      end
    end
    
    it "should be successfull" do
      get :index
      response.should be_success
    end
    
    it "should have the right title" do
      get :index
      response.should have_selector("title", content: "All links")
    end
    
    it "should have an element for every link" do
      get :index
      @links.each do |link|
        response.should have_selector("a", content: link.url.original,
                                           href: link.url.original)
      end
    end
    
    it "should paginate links" do
      8.times do
        @links << FactoryGirl.create(:link,
                                 identifier: FactoryGirl.generate(:identifier))
        url = FactoryGirl.create(:url, original: FactoryGirl.generate(:original),
                                 link_id: @links.last.id)
        rand(3).times do
          visit = FactoryGirl.create(:visit_data, link_id: @links.last.id)
        end
      end
      get :index
      response.should have_selector("div.pagination")
      response.should have_selector("a", :href => "/a/links?grid%5Bpage%5D=2",
                                         :content => "2")
    end
  end
end