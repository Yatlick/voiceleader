require 'sinatra'
require './lib/VoiceLeader.rb'
require './lib/VoiceLeader/chord.rb'
require './lib/VoiceLeader/voicelead.rb'

set :port, 8080
set :static, true
set :public_folder, "static"
set :views, "views"

get '/' do
  erb :index
end

post '/results' do
  key = params[:key]
  notes = [params[:bass], params[:tenor], params[:alto], params[:soprano]]
  music = make_music(key, notes)
  options = params[:options]
  html_info = print_info(music)
  mistakes = find_mistakes(music, options)

  erb :results, :locals => {'key' => key, 'options' => options, 'html_info' => html_info,
                            'mistakes' => mistakes}
end
