require 'net/http'
require 'json'

chartbeat_apikey = '--- YOUR APIKEY HERE ---'
chartbeat_host   = '--- YOUR  HOST  HERE ---'

url_quickstats = '/live/quickstats/v3/?apikey=%s&host=%s' % [chartbeat_apikey, chartbeat_host]
people_max = 0

http = Net::HTTP.new('api.chartbeat.com')

SCHEDULER.every '30s', :first_in => 0 do
  response = http.request(Net::HTTP::Get.new(url_quickstats))
  quickstats = JSON.parse(response.body)

  if quickstats['people']
    if quickstats['people'] > people_max
      people_max = quickstats['people']
    end

    send_event('chartbeat_people', { value: quickstats['people'], max: people_max })
  end
end