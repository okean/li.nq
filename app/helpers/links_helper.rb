module LinksHelper
  
  def count_days_bar(start, identifier)
    visit_by_day = Visit.total_grouped_by_day(start, identifier)
    (start.to_date..Date.today).map do |date|
      x = date.to_time(:utc).to_i * 1000
      y = visit_by_day[date].try { |v| v.first.total_visits } || 0
      [x, y]
    end
  end
end
