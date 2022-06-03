# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi'
<<<<<<< HEAD

get '/' do
  files = Dir.glob('memos/*').sort_by { |file| File.mtime(file) }.reverse
  @memos = files.map do |file|
    JSON.parse(File.read(file))
  end
=======
require 'pg'

def connection
  connection = PG.connect(host: '192.168.0.18', user: 'pachikuriii', dbname: 'memos', port: '5432', password: 'pass')
end

get '/' do
  connection
  @memos = connection.exec('SELECT memo_id, memo_title, memo_content FROM Memo').map { |result| result }.reverse
>>>>>>> 361f52c (app.rbを作成)
  erb :index
end

get '/memos/new' do
  erb :memos_new
end

post '/memos' do
  hash = { "id": SecureRandom.uuid, "title": CGI.escapeHTML(params['title']), "content": CGI.escapeHTML(params['content']) }
  File.open("memos/#{hash[:id]}.json", 'w') { |file| file.puts JSON.generate(hash) }
  redirect '/'
end

get '/memos/:id' do
  file = JSON.parse(File.read("memos/#{params['id']}.json"))
  @title = file['title']
  @content = file['content']
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
