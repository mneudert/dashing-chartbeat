require 'dashing'

configure do
  set :chartbeat, [
    {'apikey' => '--- YOUR APIKEY HERE ---', 'host' => '--- YOUR HOST HERE ---'},
    {'apikey' => '--- NEXT APIKEY HERE ---', 'host' => '--- NEXT HOST HERE ---'}
  ]
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application