require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true

get '/' do 

  @player_name = ''

  if session[:player_name]
    @player_name = session[:player_name]
  end

  erb :index  

end

post '/setPlayerName' do

  player_name = params[:player_name]
  session[:player_name] = player_name

  redirect '/'

end

get '/game' do
  'Game started! ' + session[:player_name]
end
 