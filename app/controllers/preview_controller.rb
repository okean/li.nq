class PreviewController < ApplicationController
  
  def index
  end
  
  def create
    enable_preview
    flash[:info] = "The Preview setting has been set"
    
    respond_to do |format|
      format.html { redirect_to preview_index_path }
      format.js
    end
  end

  def destroy
    disable_preview
    flash[:info] = "The Preview setting has been disabled"
    
    respond_to do |format|
      format.html { redirect_to preview_index_path }
      format.js
    end
  end
end
