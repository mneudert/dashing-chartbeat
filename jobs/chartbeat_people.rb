require 'net/http'
require 'json'

chartbeat_people_max = {}

SCHEDULER.every '30s', :first_in => 0 do
  if not defined? settings.chartbeat? or not settings.chartbeat.count
    next
  end

  http   = Net::HTTP.new('api.chartbeat.com')
  people = {}

  settings.chartbeat.each { |config|
    url  = '/live/quickstats/v3/?apikey=%s&host=%s' % [config['apikey'], config['host']]

    response   = http.request(Net::HTTP::Get.new(url))
    quickstats = JSON.parse(response.body)

    if quickstats['people']
      if not chartbeat_people_max[config['host']] or quickstats['people'] > chartbeat_people_max[config['host']]
        chartbeat_people_max[config['host']] = quickstats['people']
      end

      people[config['host']] = { value: quickstats['people'], max: chartbeat_people_max[config['host']] }
    end
  }

  if people.length
    send_event('chartbeat_people', { people: people })
  end
end