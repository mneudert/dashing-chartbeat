require 'dashing'

configure do
  set :chartbeat_apikey, '--- YOUR APIKEY HERE ---'
  set :chartbeat_host,   '--- YOUR  HOST  HERE ---'
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application