class Deck
  def initialize
    @suits = ["hearts","spades","diamonds","clubs"]
    @types = ["ace", "two", "three", "four", "five", "six", "seven",
              "eight", "nine", "ten", "jack", "queen", "king"]
    @cards = []
    @suits.each do |suit|
      @types.each do |type|
        @cards << Card.new(type, suit)
      end
    end
  end  

  def shuffle
    @cards.shuffle!
  end

  def getCard
    @cards.pop
  end
end 

class Card
  attr_accessor :type
  def initialize (t, s)
    @type = t
    @suit = s
  end
  def showCard
    "#{type} of #{@suit}"
  end
end

class Player
  def initialize (name, deck)
    @name = name
    @deck = deck
    @cards = []
  end

  def getName
    @name.upcase
  end
  def showHand
    @cards.each { |card| puts card.showCard}
  end
  def showOneCard
    puts @cards[0].showCard
  end
  def countCards
    total = 0
    aces = 0
    @cards.each do |card| 
      total += Game.getValue(card)
      aces = aces + 1 if  card.type == "ace"
    end
    while total > 21 && aces > 0
      total = total - 10
      aces = aces - 1
    end
    total
  end
  def hit
    @cards << @deck.getCard
  end
end

class Game
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
    puts winner.getName if winner
  end
  def self.getValue (card)
    @@valueDictionary["#{card.type}"]
  end
end




puts "Welcome to blackjack! Please enter your name:"
name = gets.chomp
puts ""

blackjackGame = Game.new
myDeck = Deck.new
myDeck.shuffle

player = Player.new(name, myDeck)
dealer = Player.new("dealer", myDeck)

player.hit
player.hit
dealer.hit
dealer.hit

puts
puts "---------- SHOWING CARDS ----------"
puts dealer.getName
dealer.showOneCard
puts "*********"

while player.countCards < 21
  puts
  puts player.getName
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
puts player.getName
player.showHand
puts
puts dealer.getName
dealer.showHand

puts ""
puts "---------- POINT COUNT ----------"
puts ""
puts player.getName
puts player.countCards
puts ""
puts dealer.getName
puts dealer.countCards

puts ""
puts "---------- WINNER ----------"
puts ""
blackjackGame.showWinner(player, dealer)




