require 'spec_helper'

describe "Users" do
  
  describe "create a short URL" do
    
    describe "on failure" do
      
      it "display an error message without creating a short link" do
        lambda do
          visit root_path
          fill_in :original, with: ""
          fill_in :custom, with: ""
          click_button "Shorten it!"
          response.should render_template('home/index')
          response.should have_selector("div", class: "alert alert-error",
                                               content: "Validation failed")
        end.should_not change(Link, :count)
      end
    end
    
    describe "on success" do
      
      it "create a short URL that represent a long URL" do
        lambda do
          test_create_short_link
          response.should render_template('home/index')
          response.should have_selector("div", class: "alert alert-success",
                                               content: "A short Url was created!")
        end.should change(Link, :count).by(1)
      end
    end
  end
  
  describe "visit the short URL" do
    
    before(:each) do
      stub_ip_api
      @example_url = FactoryGirl.create(:example_url)
      @url = root_path + @example_url.link.identifier
    end
    
    context "dissabled preview" do
      
      it "should be redirected to original URL" do
        test_disable_preview
        visit @url
        response.should redirect_to @example_url.original
      end
    end
    
    context "enabled preview" do
      
      it "should be redirected to 'preview' page" do
        visit @url
        response.should render_template('links/short_url')
      end
    end

    it "should record a visit on shortened link call" do
      lambda do
        visit @url
      end.should change(Visit, :count).by(1)
    end
  end
  
  describe "enable/disable preview" do
    
    it "can disable and enable preview" do
      visit root_path
      click_link "Preview"
      response.should render_template('preview/index')
      click_button "Disable"
      controller.should_not have_preview_enabled
      click_button "Enable"
      controller.should have_preview_enabled
    end
  end
  
  describe "view statistics" do

    before(:each) do
      stub_ip_api
      @example_url = FactoryGirl.create(:example_url)
      @url = root_path + @example_url.link.identifier
    end
    
    it "should navigate to stats page from preview link" do
      visit @url
      click_link "stats"
      response.should render_template('links/info')
    end
    
    it "should navigate to stats page from link index page" do
      visit links_path
      click_link "stats"
      response.should render_template('links/info')
    end
  end
  
  describe "share page on social networks" do
    
    it "should have approptiate buttons on Home page" do
      visit root_path
      response.should have_selector("div", class: "g-plusone", 'data-href' => root_url)
      response.should have_selector("div", class: "fb-like", 'data-href' => root_url)
      response.should have_selector("a", class: "twitter-share-button",
                                          'data-url' => root_url)
    end
  end
end
