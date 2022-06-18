# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'cgi'
require 'pg'
require 'dotenv'
Dotenv.load
CONNECTION = PG.connect(host: ENV['HOST'], user: ENV['LOGIN_NAME'], dbname: ENV['DBNAME'], password: ENV['PASSWORD'])

get '/' do
  @memos = CONNECTION.exec_params('SELECT uuid, title, content FROM Memos').map { |result| result }.reverse
  erb :index
end

get '/memos/new' do
  erb :memos_new
end

post '/memos' do
  CONNECTION.exec('INSERT INTO Memos(uuid, title, content) VALUES($1, $2, $3)',
                  [SecureRandom.uuid, params['title'], params['content']])
  redirect '/'
end

get '/memos/:id' do
  CONNECTION.exec("SELECT title, content FROM Memos WHERE uuid = '#{params[:id]}'") do |result|
    result.each do |row|
      @title = (row['title'])
      @content = (row['content'])
    end
  end
  erb :memos_show
end

get '/memos/:id/edit' do
  CONNECTION.exec("SELECT title, content FROM Memos WHERE uuid = '#{params[:id]}'") do |result|
    result.each do |row|
      @title = (row['title'])
      @content = (row['content'])
    end
  end
  erb :memos_edit
end

patch '/memos/:id' do
  CONNECTION.exec("UPDATE Memos SET title = $1, content = $2 WHERE uuid = '#{params[:id]}'", [params['title'].to_s, params['content'].to_s])
  redirect "/memos/#{params['id']}"
end

delete '/memos/:id' do
  CONNECTION.exec("DELETE FROM Memos WHERE uuid = '#{params[:id]}'")
  redirect '/'
end

not_found do
  'ファイルが存在しません'
end
