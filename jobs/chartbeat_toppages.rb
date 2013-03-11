require 'net/http'
require 'json'

SCHEDULER.every '1m', :first_in => 0 do
  if not defined? settings.chartbeat_apikey? or not defined? settings.chartbeat_host
    next
  end

  http = Net::HTTP.new('api.chartbeat.com')
  url  = '/live/toppages/v3/?apikey=%s&host=%s' % [settings.chartbeat_apikey, settings.chartbeat_host]

  response = http.request(Net::HTTP::Get.new(url))
  toppages = JSON.parse(response.body)['pages']

  if toppages
    toppages.map! do |toppage|
      { label: toppage['title'], value: toppage['stats']['people'] }
    end

    toppages.sort_by{ |toppage| toppage[:value] }

    send_event('chartbeat_toppages', { items: toppages[0..5] })
  end
end