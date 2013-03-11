require 'net/http'
require 'json'

chartbeat_people_max = 0

SCHEDULER.every '30s', :first_in => 0 do
  if not defined? settings.chartbeat_apikey? or not defined? settings.chartbeat_host
    next
  end

  http = Net::HTTP.new('api.chartbeat.com')
  url  = '/live/quickstats/v3/?apikey=%s&host=%s' % [settings.chartbeat_apikey, settings.chartbeat_host]

  response   = http.request(Net::HTTP::Get.new(url))
  quickstats = JSON.parse(response.body)

  if quickstats['people']
    if quickstats['people'] > chartbeat_people_max
      chartbeat_people_max = quickstats['people']
    end

    send_event('chartbeat_people', { value: quickstats['people'], max: chartbeat_people_max })
  end
end