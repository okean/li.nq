module LinksHelper
  
  def count_days_bar(start, identifier)
    visit_by_day = Visit.total_grouped_by_day(start, identifier)
    (start.to_date..Date.today).map do |date|
      x = date.to_time(:utc).to_i * 1000
      y = visit_by_day[date].try { |v| v.first.total_visits.to_i } || 0
      [x, y]
    end
  end
  
  def count_country_bar(identifier)
    visit_by_country = Visit.total_grouped_by_country(identifier)
    countrycodes = visit_by_country.keys
    visits = visit_by_country.values.map {|v| v.first.total_visits.to_i }
    [countrycodes, visits]
  end
  
  def get_remote_ip
    if addr = request.env["HTTP_X_FORWARDED_FOR"]
      addr.split(',').first.strip
    else
      request.env["REMOTE_ADDR"]
    end
  end
  
  def get_qr_image(url)
    "https://chart.googleapis.com/chart?cht=qr&chs=150x150&chl=#{url}"#code
  end
end
