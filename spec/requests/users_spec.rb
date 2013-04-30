require 'spec_helper'

describe "Users" do
  
  describe "creates short URLs" do
    
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
          visit root_path
          fill_in :original, with: "http://example.iana.org/"
          fill_in :custom, with: "example"
          click_button "Shorten it!"
          response.should render_template('home/index')
          response.should have_selector("div", class: "alert alert-success",
                                               content: "A short Url was created!")
        end.should change(Link, :count).by(1)
      end
    end
  end
end
