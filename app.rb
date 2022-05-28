require 'sinatra'
require 'sinatra/reloader'
require 'json'



get '/' do 
@display_title = ""
    File.open("db.json", 'r') do |file|
      ruby_hash = File.open("db.json", 'r') { |json| JSON.load(json) } 
      hashs = ruby_hash.map {|hash| hash}

       hashs.each do |hash|
        @display_title = @display_title + "<li>"
        @display_title = @display_title + "<a href=\"memos/#{hash["id"]}\">"
        @display_title = @display_title + "#{hash["title"]}"
        @display_title = @display_title + "</a>"
        @display_title = @display_title + "</li>\n"
      end
    end
erb :index
end

get '/memos/new' do 
  erb :memos_new
end

post '/memos' do
  @title = params["title"]
  @content = params["content"]

    data = File.open("db.json", 'r') { |json| JSON.load(json) } 
    ids = []
    data.each do|hash|
       ids << "#{hash["id"]}"
    end
    max = ids.max.to_i

    new_memo = { "id": "#{max + 1}", "title": @title, "content": @content }
    data << new_memo
    File.open("db.json", 'w') { |json| JSON.dump(data, json)}
   
  redirect '/'
end

get '/memos/*' do |id|

  
  erb :memos_new
end



