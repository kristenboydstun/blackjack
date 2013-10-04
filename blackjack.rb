class Deck
  def initialize
    @suits = ["hearts","spades","diamonds","clubs"]
    @cards = []
    @valueDictionary = {"ace" => 11, "two" => 2, "three" => 3, "four" => 4, "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9, "ten" => 10, "jack" => 10, "queen" => 10, "king" => 10}

    @suits.each do |suit|
      @valueDictionary.keys.each do |name|
        @cards << CardHolder.new(name, suit, @valueDictionary["#{name}"])
      end
    end
  end  

  def numCards
    @cards.length
  end

  def getCards
    @cards
  end 

  def shuffle
    @cards.shuffle!
  end

  def getCard
    @cards.pop
  end
end 

CardHolder = Struct.new(:name, :suit, :value) do
  def showCard
    "#{name} of #{suit}"
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
      total += card.value
      aces = aces + 1 if  card.name == "ace"
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
    puts winner.getName unless winner.nil?
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

#puts "Number of cards in the deck:"
#puts myDeck.numCards

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




