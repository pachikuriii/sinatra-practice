# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'cgi'

get '/' do
  files = Dir.glob('memos/*').sort_by { |file| File.mtime(file) }.reverse
  @memos = files.map do |file|
    JSON.parse(File.read(file))
  end
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
  file = JSON.parse(File.read("memos/#{params['id']}.json"))
  @title = file['title']
  @content = file['content']

  erb :memos_edit
end

patch '/memos/:id' do
  File.open("memos/#{params['id']}.json", 'w') do |file|
    hash = { "id": params['id'], "title": CGI.escapeHTML(params['title']), "content": CGI.escapeHTML(params['content']) }
    JSON.dump(hash, file)
  end
  redirect "/memos/#{params['id']}"
end

delete '/memos/:id' do
  File.delete("memos/#{params['id']}.json")
  redirect '/'
end

not_found do
  'ファイルが存在しません'
end
