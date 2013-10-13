class Card
  attr_accessor :type, :suit

  def initialize (t, s)
    @type = t
    @suit = s
  end

  def display
    "#{type} of #{suit}"
  end

  def to_s
    display
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
    @cards.each { |card| puts card}
  end

  def showOneCard
    puts @cards[0]
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
  
  def initialize
    greet

    myDeck = Deck.new
    @player = Player.new(@name, myDeck)
    @dealer = Player.new("dealer", myDeck)
  end

  def start
    dealCards

    playerTakesTurn
    dealerTakesTurn

    showHands (hidden=false)
    puts
    puts "---------- WINNER ----------"
    puts
    getWinner
    puts @winner.name if @winner
  end

  def playerTakesTurn
    while @player.countCards < 21

      showHands (hidden=true)    

      puts ">>>> Hit (h) or stay (s)?"
      move = gets.chomp.downcase

      move == "h" ? @player.hit : break
    end
  end

  def dealerTakesTurn
    @dealer.hit while @dealer.countCards <= 16
  end

  def dealCards
    @player.hit
    @player.hit
    @dealer.hit
    @dealer.hit
  end

  def greet
    puts "Welcome to blackjack! Please enter your name:"
    @name = gets.chomp
    puts ""
  end

  def showHands (hidden)
    puts
    puts "---------- SHOWING CARDS ----------"
    puts @dealer.name
    if hidden
      @dealer.showOneCard
      puts "*********"
    else
      @dealer.showHand
    end
    puts
    puts @player.name
    @player.showHand
    puts
  end

  def getWinner
    cards_player = @player.countCards
    cards_dealer = @dealer.countCards
    # tie
    if cards_player == cards_dealer
      puts "TIE"
    elsif cards_player > 21 && cards_dealer > 21
      puts "EVERYONE OVER 21"
    elsif cards_player > 21
      @winner = @dealer
    elsif cards_dealer > 21
      @winner = @player
    else
      @winner = cards_player > cards_dealer ? @player : @dealer
    end
  end

  # card has a value in the context of a blackjack game
  def self.getValue (card)
    @@valueDictionary["#{card.type}"]
  end
end


game = Blackjack.new
game.start
