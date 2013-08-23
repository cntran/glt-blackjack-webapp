require 'rubygems'
require 'sinatra'
load 'blackjack.rb'

set :sessions, true

get '/' do 

  session.delete(:player_name)
  session.delete(:blackjack)

  erb :index  

end

post '/setPlayerName' do

  player_name = params[:player_name]
  session[:player_name] = player_name

  redirect '/welcome'

end

get '/welcome' do
  @player_name = ''

  if session[:player_name]
    @player_name = session[:player_name]
  end

  erb :welcome
end


get '/game' do

  @player_name = session[:player_name]
  # deal cards to dealer and player
  @blackjack = BlackJack.new(session[:player_name])
  @blackjack.deal_cards

  erb :game

end
 