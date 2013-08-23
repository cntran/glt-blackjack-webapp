class Card

  attr_accessor :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    puts suit + ', ' + value
  end

end

class Deck

  attr_accessor :cards

  def initialize()
    @cards = []
    suits = ['C', 'D', 'H', 'S']
    cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

    deck = suits.product(cards)
    deck.each do |card|
      @cards.push(Card.new(card[0], card[1]))
    end

  end

  def shuffle
    cards.shuffle!
  end

  def deal
    cards.pop
  end

  def to_s
    cards.each do |card|
      puts card.suit + ' ' + card.value + ', '
    end
  end

end


class Player

  attr_accessor :name, :cards

  def initialize(name)
    @name = name
    @cards = []
  end

  def add_card(card)
    cards.push(card)
  end

  def show_cards
    print name 
    print " cards: [ "
    cards.each do |card|
      print "#{card.value} "
    end
    puts "]"
  end

end

class BlackJackDealer < Player

  def initialize(name)
    super
  end

  def show_hole_card
     puts  name + " cards: [ * #{cards[1].value} ]"
  end

end

class BlackJack

  attr_accessor :deck, :player, :dealer

  def initialize(player_name)
    
    @player = Player.new(player_name)
    @dealer = BlackJackDealer.new("Dealer")
    # Set new deck, shuffle
    @deck = Deck.new
    deck.shuffle

  end

  def deal_cards
    player.add_card(deck.deal)
    dealer.add_card(deck.deal)
    player.add_card(deck.deal)
    dealer.add_card(deck.deal)
  end

  def get_hand_value(cards)

    hand_value = 0

    card_values = cards.map{ |a| a.value }
    aces_count = 0
    card_values.each do |value|

      if value == 'A'
        hand_value += 11
        aces_count += 1
      elsif value.to_i == 0 # non numeric value cards
        hand_value += 10
      else
        hand_value += value.to_i
      end

    end

    # Check for busts relating to Aces being counted at 11
    while aces_count > 0
      if hand_value > 21
        hand_value -= 10
      end
      aces_count -= 1
    end

    return hand_value

  end

  def blackjack?(card_value)
    card_value == 21 ? true : false
  end

  def busted?(card_value)
    card_value > 21 ? true : false
  end

end