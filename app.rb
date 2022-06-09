# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi'
require 'pg'

def connection
  connection = PG.connect(host: '192.168.0.18', user: 'pachikuriii', dbname: 'memos', port: '5432', password: '')
end

get '/' do
  connection
  @memos = connection.exec('SELECT memo_id, memo_title, memo_content FROM Memo').map { |result| result }.reverse
  erb :index
end

get '/memos/new' do
  erb :memos_new
end

post '/memos' do
  connection
  connection.exec("INSERT INTO Memo(memo_id, memo_title, memo_content) VALUES ('#{SecureRandom.uuid}', '#{params['title']}', '#{params['content']}')")
  redirect '/'
end

get '/memos/:id' do
  connection
  connection.exec("SELECT memo_title, memo_content FROM Memo WHERE memo_id = '#{params[:id]}'") do |result|
    result.each do |row|
      @title = (row['memo_title']).to_s
      @content = (row['memo_content']).to_s
    end
  end
  erb :memos_show
end

get '/memos/:id/edit' do
  connection
  connection.exec("SELECT memo_title, memo_content FROM Memo WHERE memo_id = '#{params[:id]}'") do |result|
    result.each do |row|
      @title = (row['memo_title']).to_s
      @content = (row['memo_content']).to_s
    end
  end
  erb :memos_edit
end

patch '/memos/:id' do
  connection
  connection.exec("UPDATE Memo SET memo_title = '#{params['title']}', memo_content = '#{params['content']}' WHERE memo_id = '#{params[:id]}'")
  redirect "/memos/#{params['id']}"
end

delete '/memos/:id' do
  connection
  connection.exec("DELETE FROM Memo WHERE memo_id = '#{params[:id]}'")
  redirect '/'
end

not_found do
  'ファイルが存在しません'
end
