require 'rubygems'
require 'sinatra'

set :sessions, true

helpers do

  def calculate_total(cards)
    arr = cards.map{|element| element[1]}

    total = 0
    arr.each do |a|
      if a == "A"
        total += 11
      else
        total += a.to_i == 0 ? 10 : a.to_i
      end
    end

    #correct for Aces
    arr.select{|element| element == "A"}.count.times do
      break if total <= 21
      total -= 10
    end

    total
  end


  def display_card_image(card)

    image_src = ''
    if card[0] == 'C'
      image_src = 'clubs_'
    elsif card[0] == 'D'
      image_src = 'diamonds_'
    elsif card[0] == 'H'
      image_src = 'hearts_'
    elsif card[0] == 'S'
      image_src = 'spades_'
    end

    if card[1].to_i == 0 
      if card[1] == 'J'
        image_src += 'jack.jpg'
      elsif card[1] == 'Q'
        image_src += 'queen.jpg'
      elsif card[1] == 'K'
        image_src += 'king.jpg'
      elsif card[1] == 'A'
        image_src += 'ace.jpg'
      end
    else
      image_src += card[1].to_s + '.jpg'
    end

    image_src

  end

end


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

  suits = ['C', 'D', 'H', 'S']
  values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  session[:deck] = suits.product(values).shuffle!

  # deal cards
  session[:dealer_cards] = []
  session[:player_cards] = []
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop

  erb :game

end

post '/game/hit' do

  session[:player_cards] << session[:deck].pop
  hand_value = calculate_total(session[:player_cards])
  if hand_value > 21
    @error = 'Sorry you busted! ' 
  end

  erb :game

end

post '/game/stay' do



  erb :game

end


 