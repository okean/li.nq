class ApplicationController < ActionController::Base
  protect_from_forgery
  include PreviewHelper

  after_filter :flash_to_headers
  
  def diff(time)
    Time.now - time
  end
  
  private
  
    def flash_to_headers
      return unless request.xhr?
      response.headers['X-Message'] = flash_message
      response.headers["X-Message-Type"] = flash_type.to_s

      flash.discard # don't want the flash to appear when you reload page
    end

    def flash_message
      [:error, :warning, :info, :success].each do |type|
        return flash[type] unless flash[type].blank?
      end
    end

    def flash_type
      [:error, :warning, :info, :success].each do |type|
        return type unless flash[type].blank?
      end
    end
end
