require 'sinatra'
require 'sinatra/reloader'
require 'net/http'
require 'uri'
require 'json'



get '/' do 

  
    File.open('db.json') do |f|
        array = JSON.load(f)
        array.each do |hash|
            @hash = hash

        end
    end

  erb :index
end



# get '/newmemo' do 
#   erb :newmemo
#   end
