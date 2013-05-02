module PreviewHelper
  ENABLE = 1
  DISABLE = 0
  
  def enable_preview
     cookies.permanent.signed[:preview] = ENABLE
  end
  
  def disable_preview
    cookies.permanent.signed[:preview] = DISABLE
  end
  
  def preview_token
    cookies.signed[:preview] || nil
  end
  
  def has_preview_enabled?
    cookies.signed[:preview] == ENABLE
  end
  
  def first_time_preview?
    preview_token.nil?
  end
end
