class LinksController < ApplicationController
  
  def create
    custom = params[:custom].empty? ? nil : params[:custom]
    begin
      @link = Link.shorten(params[:original], custom)
      if diff(@link.created_at) < 1
        flash[:success] = "A short Url was created! Share it!"
      else
        flash[:notice] = "Current link is already shortened! Use it!"
      end
    rescue => e 
      flash[:error] = e.message
    end
    
    respond_to do |format|
      format.html { render 'home/index' }
      format.js
    end
  end
end
