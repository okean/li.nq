namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Rake::Task['db:reset'].invoke
    make_links
    make_visits
  end
end

def make_links
  10.times do
    @link = Link.shorten(Faker::Internet.url)
  end
end

def make_visits
  Link.all(limit: 3).each do |link|
    50.times do
      visit = link.visits.new(ip: Faker::Internet.ip_v4_address)
      visit.created_at = time_rand(Time.local(2013, 1, 1))
      visit.save
    end
  end
end

def time_rand from = 0.0, to = Time.now
  Time.at(from + rand * (to.to_f - from.to_f))
end