require 'viewpoint'
require 'business_time'
require 'dotenv/load'
include Viewpoint::EWS

endpoint = ENV['MY_ENDPOINT']
user = ENV['MY_EMAIL']
pass = ENV['MY_PASSWORD']

cli = Viewpoint::EWSClient.new endpoint, user, pass
calendar = cli.get_folder(:calendar, opts = {act_as: user})
events = calendar.items
events.select! {|item| item.my_response_type == "Organizer" }

years = []

events.each do |item|
  year = item.start.strftime("%Y")
  unless years.include?(year)
    years.push(year)
    puts "#{year}--------------------------------------------"
  end
  puts "#{item.start.strftime('%m/%d/%Y')} - #{item.subject} (#{item.start.business_days_until(item.end)} business days)"
end
