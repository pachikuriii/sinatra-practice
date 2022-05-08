require 'sinatra'
require 'sinatra/reloader' 

get '/' do
  'Good day!'
end

# ここから
get '/path/to' do
  "this is [/path/to]"
end
# ここまでを追加

get '/hello/*' do |name|
  "hello #{name}. how are you?"
end