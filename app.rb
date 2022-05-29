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
  @title = params["title"]
  @content = params["content"]

    hash = { "id": SecureRandom.uuid, "title": @title, "content": @content }
    File.open("memos/#{hash[:id]}.json", 'w') { |file| file.puts JSON.generate(hash) }  
   
  redirect '/'
end

get '/memos/:id' do
   file = JSON.load(File.open("memos/#{params["id"]}.json"))
   @title = file["title"]
   @content = file["content"]
  erb :memos_show
end




get '/memos/*/edit' do |id|
  
  @title = titles
  @content = contents
  erb :memos_edit
end



