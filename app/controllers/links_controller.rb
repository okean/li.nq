class LinksController < ApplicationController
  
  def index
    @links_grid = initialize_grid(Link,
        include: [:url, :visits],
        order: 'links.created_at',
        order_direction: 'desc',
        per_page: 10)
  end
  
  def info
    @link = Link.find_by_identifier(params[:short_url])
    
    if @link.nil?
      flash[:info] = "This link is not defined yet."
      redirect_to root_path
    else
      @num_of_days = (params[:num_of_days] || 15).to_i.days.ago
      @count_days_bar = count_days_bar(@num_of_days, params[:short_url])
      
      @count_country_bar_countrycodes, @count_country_bar_visits =
          count_country_bar(params[:short_url])
    end
  end
  
  def short_url
    @link = Link.find_by_identifier(params[:short_url])
    
    if @link.nil?
      flash[:info] = "I couldn't find a link for the URL you clicked."
      redirect_to root_path
    else
      @link.visits.create(ip: get_remote_ip)
      
      if first_time_preview? or has_preview_enabled?
        render 'short_url'
      else
        redirect_to @link.url.original, status: 301
      end
    end
  end
  
  def create
    custom = params[:custom].empty? ? nil : params[:custom]
    begin
      @link = Link.shorten(params[:original], custom)
      if diff(@link.created_at) < 1
        flash[:success] = "A short Url was created! Share it!"
      else
        flash[:warning] = "Current link is already shortened! Use it!"
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
