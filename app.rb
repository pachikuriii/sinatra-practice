require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/' do 
      files = Dir.glob("memos/*")
      @memos = files.map do |file|
         JSON.load(File.open("#{file}"))
      end
erb :index
end

get '/memos/new' do 
  erb :memos_new
end

post '/memos' do
    hash = { "id": SecureRandom.uuid, "title": params["title"], "content": params["content"] }
    File.open("memos/#{hash[:id]}.json", 'w') { |file| file.puts JSON.generate(hash) }  
   
    redirect '/'
end

get '/memos/:id' do
   file = JSON.load(File.open("memos/#{params["id"]}.json"))
   @title = file["title"]
   @content = file["content"]
  erb :memos_show
end

get '/memos/:id/edit' do
  file = JSON.load(File.open("memos/#{params["id"]}.json"))
  @title = file["title"]
  @content = file["content"]
  erb :memos_edit
end

patch '/memos/:id' do
  File.open("memos/#{params["id"]}.json", 'w') do |file|
  hash = {"id": params["id"], "title": params["title"], "content": params["content"] }
  JSON.dump(hash, file)
  end

  redirect '/'
end

delete '/memos/:id' do
  File.delete("memos/#{params["id"]}.json")
  redirect '/'
end
