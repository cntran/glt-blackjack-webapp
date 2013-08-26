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
  session.delete(:player_balance)
  session.delete(:deck)
  session.delete(:player_cards)
  session.delete(:dealer_cards)

  erb :index  

end

get '/rules' do

  erb :rules

end

get '/about' do

  erb :about

end

post '/setPlayerName' do

  player_name = params[:player_name]

  if player_name == ''
    @error = 'You didn\'t enter your name.'
    halt( erb :index )
  end

  session[:player_name] = player_name
  session[:player_balance] = 100

  redirect '/welcome'

end

get '/welcome' do

  erb :welcome
end


post '/game' do

  # validate bet amount
  bet = params['bet']
  if bet.to_i == 0
    @error = 'Please enter in a numeric value.'
    halt( erb :welcome)
  elsif bet.to_i > session[:player_balance].to_i
    @error = 'You don\'t have enough cash to bet that amount.'
    halt( erb :welcome)
  end

  session[:bet] = bet

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

  @show_player_actions = true
  @dealer_turn = false
  erb :game

end

post '/game/hit' do

  @show_player_actions = true
  @game_over = false
  @dealer_turn = false

  session[:player_cards] << session[:deck].pop
  hand_value = calculate_total(session[:player_cards])
  if hand_value > 21
    @error = 'Looks like you busted. :(' 
    @show_player_actions = false
    @game_over = true
    session[:player_balance] = session[:player_balance].to_i - session[:bet].to_i
  end

  erb :game

end

post '/game/stay' do

  @dealer_turn = true
  @show_player_actions = false
  @game_over = false

  player_hand_value = calculate_total(session[:player_cards])
  dealer_hand_value = calculate_total(session[:dealer_cards])


  if dealer_hand_value > 16 # end game and determine winner

    if player_hand_value > dealer_hand_value  
      @success = 'You win! :)'
      session[:player_balance] = session[:player_balance].to_i + session[:bet].to_i
    elsif player_hand_value < dealer_hand_value
      @error = 'Sorry, you lose. :('
      session[:player_balance] = session[:player_balance].to_i - session[:bet].to_i
    elsif player_hand_value == dealer_hand_value
      @success = 'Its a push. :/'
    end

    @game_over = true

  end

  erb :game

end

post '/game/hit/dealer' do

  @show_player_actions = false
  @game_over = false
  @dealer_turn = true

  session[:dealer_cards] << session[:deck].pop
  player_hand_value = calculate_total(session[:player_cards])
  dealer_hand_value = calculate_total(session[:dealer_cards])

  if dealer_hand_value > 21
    @success = 'Dealer busts! You win! :)' 
    @game_over = true
  elsif dealer_hand_value > 16

    if player_hand_value > dealer_hand_value  
      @success = 'You win! :)'
      session[:player_balance] = session[:player_balance].to_i + session[:bet].to_i
    elsif player_hand_value < dealer_hand_value
      @error = 'Sorry, you lose. :('
      session[:player_balance] = session[:player_balance].to_i - session[:bet].to_i
    elsif player_hand_value == dealer_hand_value
      @success = 'Its a push. :/'
    end

    @game_over = true

  end

  erb :game

end


 