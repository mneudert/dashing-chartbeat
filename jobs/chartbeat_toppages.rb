require 'net/http'
require 'json'

chartbeat_apikey = '--- YOUR APIKEY HERE ---'
chartbeat_host   = '--- YOUR  HOST  HERE ---'

url_toppages = '/live/toppages/v3/?apikey=%s&host=%s' % [chartbeat_apikey, chartbeat_host]

http = Net::HTTP.new('api.chartbeat.com')

SCHEDULER.every '1m', :first_in => 0 do
  response = http.request(Net::HTTP::Get.new(url_toppages))
  toppages = JSON.parse(response.body)['pages']

  if toppages
    toppages.map! do |toppage|
      { label: toppage['title'], value: toppage['stats']['people'] }
    end

    toppages.sort_by{ |toppage| toppage[:value] }

    send_event('chartbeat_toppages', { items: toppages[0..5] })
  end
end