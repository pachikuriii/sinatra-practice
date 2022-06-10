# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'cgi'
require 'pg'

CONNECTION = PG.connect(host: '192.168.0.18', user: 'pachikuriii', dbname: 'memos', port: '5432', password: '')

get '/' do
  @memos = CONNECTION.exec_params('SELECT memo_id, memo_title, memo_content FROM Memo').map { |result| result }.reverse
  erb :index
end

get '/memos/new' do
  erb :memos_new
end

post '/memos' do
  CONNECTION.exec('INSERT INTO Memo(memo_id, memo_title, memo_content) VALUES($1, $2, $3)',
                  [SecureRandom.uuid.to_s, params['title'].to_s, params['content'].to_s])
  redirect '/'
end

get '/memos/:id' do
  CONNECTION.exec("SELECT memo_title, memo_content FROM Memo WHERE memo_id = '#{params[:id]}'") do |result|
    result.each do |row|
      @title = (row['memo_title']).to_s
      @content = (row['memo_content']).to_s
    end
  end
  erb :memos_show
end

get '/memos/:id/edit' do
  CONNECTION.exec("SELECT memo_title, memo_content FROM Memo WHERE memo_id = '#{params[:id]}'") do |result|
    result.each do |row|
      @title = (row['memo_title']).to_s
      @content = (row['memo_content']).to_s
    end
  end
  erb :memos_edit
end

patch '/memos/:id' do
  CONNECTION.exec("UPDATE Memo SET memo_title = $1, memo_content = $2 WHERE memo_id = '#{params[:id]}'", [params['title'].to_s, params['content'].to_s])
  redirect "/memos/#{params['id']}"
end

delete '/memos/:id' do
  CONNECTION.exec("DELETE FROM Memo WHERE memo_id = '#{params[:id]}'")
  redirect '/'
end

not_found do
  'ファイルが存在しません'
end
