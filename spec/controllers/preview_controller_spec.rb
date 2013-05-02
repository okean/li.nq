require 'spec_helper'

describe PreviewController do
  
  describe "GET 'index'" do
    render_views
      
    it "should be successfull" do
      get :index
      response.should be_success
    end
    
    it "should have the right title" do
      get :index
      response.should have_selector("title", content: "Preview")
    end
  end
  
  describe "POST 'create'" do
    
    it "should enable preview" do
      post :create
      controller.should have_preview_enabled
    end
    
    it "should have a notification message" do
      post :create
      flash[:info] =~ /The Preview setting has been set/i
    end
    
    it "should redirect to 'preview' page" do
      post :create
      response.should redirect_to preview_index_path
    end
    
    it "should enable preview usig Ajax" do
      xhr :post, :create
      response.should be_success
      controller.should have_preview_enabled
    end
  end
  
  describe "DELETE 'destroy'" do
    
    it "should disable preview" do
      delete :destroy, id: 1
      controller.should_not have_preview_enabled
    end
    
    it "should have a notification message" do
      delete :destroy, id: 1
      flash[:info] =~ /The Preview setting has been disabled/i
    end
    
    it "should redirect to 'preview' page" do
      delete :destroy, id: 1
      response.should redirect_to preview_index_path
    end
    
    it "should disable preview usig Ajax" do
      xhr :delete, :destroy, id: 1
      response.should be_success
      controller.should_not have_preview_enabled
    end
  end
end
