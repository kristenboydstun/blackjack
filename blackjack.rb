class Card
  attr_accessor :type

  def initialize (t, s)
    @type = t
    @suit = s
  end

  def display
    "#{type} of #{@suit}"
  end
end

class Deck
  @@suits = ["hearts","spades","diamonds","clubs"]
  @@types = ["ace", "two", "three", "four", "five", "six", "seven",
              "eight", "nine", "ten", "jack", "queen", "king"]

  # fill deck and mix cards
  def initialize
    @cards = []
    @@suits.each do |suit|
      @@types.each do |type|
        @cards << Card.new(type, suit)
      end
    end
    mixcards
  end  

  private
  def mixcards
    @cards.shuffle!
  end

  public
  def dealCard
    @cards.pop
  end
end 

class Player

  def initialize (name, deck)
    @name = name
    @deck = deck
    @cards = []
  end

  def name
    @name.upcase
  end

  def showHand
    @cards.each { |card| puts card.display}
  end

  def showOneCard
    puts @cards[0].display
  end

  def countCards
    total = 0
    aces = 0
    @cards.each do |card| 
      total += Blackjack.getValue(card)
      aces = aces + 1 if  card.type == "ace"
    end
    while total > 21 && aces > 0
      total = total - 10
      aces = aces - 1
    end
    total
  end

  def hit
    @cards << @deck.dealCard
  end
end

class Blackjack
  @@valueDictionary = {"ace" => 11, "two" => 2, "three" => 3, "four" => 4, "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9, "ten" => 10, "jack" => 10, "queen" => 10, "king" => 10}
  
  def showWinner (player1, player2)
    cards1 = player1.countCards
    cards2 = player2.countCards
    # tie
    if cards1 == cards2
      puts "TIE"
    elsif cards1 > 21 && cards2 > 21
      puts "EVERYONE OVER 21"
    elsif cards1 > 21
      winner = player2
    elsif cards2 > 21
      winner = player1
    else
      winner = cards1 > cards2 ? player1 : player2
    end
    puts winner.name if winner
  end

  # card has a value in the context of a blackjack game
  def self.getValue (card)
    @@valueDictionary["#{card.type}"]
  end
end




puts "Welcome to blackjack! Please enter your name:"
name = gets.chomp
puts ""

blackjackGame = Blackjack.new
myDeck = Deck.new

player = Player.new(name, myDeck)
dealer = Player.new("dealer", myDeck)

player.hit
player.hit
dealer.hit
dealer.hit

puts
puts "---------- SHOWING CARDS ----------"
puts dealer.name
dealer.showOneCard
puts "*********"

while player.countCards < 21
  puts
  puts player.name
  player.showHand

  puts
  puts "Hit or stay?"
  move = gets.chomp.downcase

  move == "hit" ? player.hit : break
end

dealer.hit while dealer.countCards <= 16

puts
puts "---------- GAME OVER ----------"
puts
puts player.name
player.showHand
puts
puts dealer.name
dealer.showHand

puts ""
puts "---------- POINT COUNT ----------"
puts ""
puts player.name
puts player.countCards
puts ""
puts dealer.name
puts dealer.countCards

puts ""
puts "---------- WINNER ----------"
puts ""
blackjackGame.showWinner(player, dealer)




