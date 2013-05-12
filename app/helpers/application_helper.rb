module ApplicationHelper
  
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  def active_tab(page)
    page = page.gsub(/#.*/, '')
    return 'active' if current_page?(page)
  end
  
  def tab(body, url)
    content_tag(:li, nil, class: active_tab(url)) do
      link_to body, url
    end
  end
end
