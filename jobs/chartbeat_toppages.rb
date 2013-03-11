require 'net/http'
require 'json'

SCHEDULER.every '30s', :first_in => 0 do
  if not defined? settings.chartbeat? or not settings.chartbeat.count
    next
  end

  http     = Net::HTTP.new('api.chartbeat.com')
  toppages = {}

  settings.chartbeat.each { |config|
    url  = '/live/toppages/v3/?apikey=%s&host=%s' % [config['apikey'], config['host']]

    response = http.request(Net::HTTP::Get.new(url))
    pages    = JSON.parse(response.body)['pages']

    if pages
      pages.map! do |page|
        { label: page['title'], value: page['stats']['people'] }
      end

      pages.sort_by { |page| page['value'] }

      toppages[config['host']] = { items: pages[0..5] }
    end
  }

  if toppages.length
    send_event('chartbeat_toppages', { toppages: toppages })
  end
end