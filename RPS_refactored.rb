# 1. Keeping score
#    - For keeping score, each player's score made most sense as an
#      attribute or state of both the human and computer objects. On
#      instantiation of a human or computer object the constructor method
#      for the player class initiates the instance variable @score and
#      assigns it to the integer zero. Both Human and Computer sub-class from
#      Player class, therefore the constructor method in Player is able to
#      assign this instance variable to both objects. Then I created a method in
#      the RPSGame Class to reassign each each objects's @score instance
#      variable to the current value plus one if they win. There are several
#      score related methods in the RPSGame class(display_score, reset_score,
#      etc.). Perhaps I should have created a scorable module to assign all
#      score related methods and then just included it in RPSGame class? But,
#      then again, score seems to be a function of the game itself and might
#      belong in the RPSGame class.

# 2. After adding lizard and Spock to the game, the display winner method
#    becomes too complex for rubocop.

# 3. Add a class for each move
#    - I created a namespace module called moves and then mixed it into
#      the RPSGame class
#    - The one major pro for this is that the display winner method is no longer
#      too complex when the method gets spreat around among the classes. For
#      example, each move class has it's own beat method.
#    - A con for this approach is the fact that when the Human and Computer
#      ojects are instantiated by the RPSGame class, they are collaborator
#      objects. When each of their move objects are instantiated, they then have
#      collaborator objects as a state. This seems sort of messy - a
#      collaborator object with a collaborator object state.

# 4. Keep track of history of moves
#    - in order to keep track of the Human and Computer object's move, I first
#      added an instance variable called @move_history to the Player class and
#      assinged it to an empty array. I then created a keep_move_history
#      method that appends the value of each move chosen to the repsective
#      move_history array (human or computer object). In order to display these
#      moves I created a method called display moves that iterates over each
#      move and uses a counter, that increments on each iteration by one, and
#      prints out the value. It lists all moves made by each player, and in what
#      round

# 5. Computer personalities
#    - To give each computer object name a different personality related to
#      their choices, I just added a case statment that assigns certain choices
#      for each name. The arrays are all strucured differently. Sample is
#      called on arrays with fewer choices than the original array, or multiple
#      string objects with a value of one choice name are in the array to
#      increase the likelyhood that one will be chosen over another.

class Player
  CHOICES = ['rock', 'paper', 'scissors', 'spock', 'lizard']

  attr_accessor :move, :name, :move_history, :score

  def initialize
    set_name
    @move_history = []
    @score = 0
  end

  def assign_move(choice)
    case choice
    when 'rock' then self.move = Moves::Rock.new
    when 'paper' then self.move = Moves::Paper.new
    when 'scissors' then self.move = Moves::Scissors.new
    when 'lizard' then self.move = Moves::Lizard.new
    when 'spock' then self.move = Moves::Spock.new
    end
  end

  def keep_move_history
    move_history << move.value
  end

  def display_move_history
    round_number = 1
    puts "#{name} made the following moves:"
    move_history.each do |move|
      puts "#{move} in round #{round_number}"
      round_number += 1
    end
  end
end

module Moves
  class Spock
    attr_reader :value

    def initialize
      @value = 'Spock'
    end

    def beats(other_player)
      other_player.move.instance_of?(Moves::Rock) ||
        other_player.move.instance_of?(Moves::Scissors)
    end

    def battle_outcome(other_player)
      if other_player.move.instance_of?(Moves::Scissors)
        puts "**** Spock SMASHES scissors!!! ****"
      elsif other_player.move.instance_of?(Moves::Rock)
        puts "**** Spock VAPORIZES rock!!! ****"
      end
    end
  end

  class Lizard
    attr_reader :value

    def initialize
      @value = 'lizard'
    end

    def beats(other_player)
      other_player.move.instance_of?(Moves::Spock) ||
        other_player.move.instance_of?(Moves::Paper)
    end

    def battle_outcome(other_player)
      if other_player.move.instance_of?(Moves::Spock)
        puts "**** Lizard POISONS Spock!!! ****"
      elsif other_player.move.instance_of?(Moves::Paper)
        puts "**** Lizard EATS paper!!! ****"
      end
    end
  end

  class Rock
    attr_reader :value

    def initialize
      @value = 'rock'
    end

    def beats(other_player)
      other_player.move.instance_of?(Moves::Scissors) ||
        other_player.move.instance_of?(Moves::Lizard)
    end

    def battle_outcome(other_player)
      if other_player.move.instance_of?(Moves::Scissors)
        puts "**** Rock SMASHES scissors!!! ****"
      elsif other_player.move.instance_of?(Moves::Lizard)
        puts "**** Rock CRUSHES lizard!!! ****"
      end
    end
  end

  class Paper
    attr_reader :value

    def initialize
      @value = 'paper'
    end

    def beats(other_player)
      other_player.move.instance_of?(Moves::Rock) ||
        other_player.move.instance_of?(Moves::Spock)
    end

    def battle_outcome(other_player)
      if other_player.move.instance_of?(Moves::Rock)
        puts "**** Paper COVERS Rock!!! ****"
      elsif other_player.move.instance_of?(Moves::Spock)
        puts "**** Rock DISPROVES Spock!!! ****"
      end
    end
  end

  class Scissors
    attr_reader :value

    def initialize
      @value = 'scissors'
    end

    def beats(other_player)
      other_player.move.instance_of?(Moves::Paper) ||
        other_player.move.instance_of?(Moves::Lizard)
    end

    def battle_outcome(other_player)
      if other_player.move.instance_of?(Moves::Paper)
        puts "**** Scissors CUTS Paper!!! ****"
      elsif other_player.move.instance_of?(Moves::Lizard)
        puts "**** Scissors DECAPITATES Lizard!!! ****"
      end
    end
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, lizard, Spock or scissors:"
      choice = gets.chomp.downcase
      break if CHOICES.include? choice
      puts "Sorry, invalid choice."
    end
    assign_move(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', "Hal", 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    case name
    when "Hal" then choice = 'Spock'
    when 'Sonny' then choice = (CHOICES + ["lizard", "lizard", "lizard"]).sample
    when 'R2D2' then choice = ['rock', 'paper', 'scissors'].sample
    when 'Chappie' then choice = ['Spock', 'Lizard'].sample
    when 'Number 5' then choice = ['rock', 'rock', 'scissors'].sample
    end
    assign_move(choice)
  end
end

class RPSGame
  WINNING_SCORE = 10

  include Moves

  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    space
    puts "Hello #{human.name}! Welcome to Rock, Paper, Scissors, Lizard, Spock!"
    space
    puts "Your opponent is #{computer.name}"
    puts rules
  end

  def rules
    <<-HEREDOC

    Play until you or #{computer.name} reach #{WINNING_SCORE} points.
    You will be prompted to choose rock, paper, scissors, lizard or Spock.

      - scissors cuts paper and decapitates lizard
      - rock crushes lizard and smashes scissors
      - Spock smashes scissors and vaporizes rock
      - lizard poisons Spock and eats paper
      - paper covers rock and disproves Spock

    Good Luck!
    HEREDOC
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock!"
  end

  def clear_screen
    system('clear') || system('cls')
  end

  def space
    puts ''
  end

  def continue_playing?
    answer = nil
    loop do
      space
      puts "Press RETURN/ENTER to continue or 'q' to quit."
      answer = gets
      break if ["q\n", "\n"].include? answer.downcase
      puts "Sorry, must be 'q' or RETURN/ENTER."
    end
    clear_screen
    return true if answer == "\n"
  end

  def display_moves
    space
    puts "-=-=-=-=-=-=-=-=-=-=-=-=-"
    puts "#{computer.name} chooses #{computer.move.value}."
    puts "#{human.name} chooses #{human.move.value}.      "
    puts "-=-=-=-=-=-=-=-=-=-=-=-=-"
    space
  end

  def keep_score
    if human.move.beats(computer)
      human.score += 1
    elsif computer.move.beats(human)
      computer.score += 1
    end
  end

  def reset_score
    human.score = 0
    computer.score = 0
  end

  def reset_move_history
    human.move_history = []
    computer.move_history = []
  end

  def display_score
    space
    puts '-=-=-=-=-=-=-=-=-=-=-=-=-='
    puts "The Current Score is:"
    puts "#{computer.name}: #{computer.score}"
    puts "#{human.name}: #{human.score}"
    puts '-=-=-=-=-=-=-=-=-=--=-=-=-'
    space
  end

  def winning_score_reached
    human.score == WINNING_SCORE || computer.score == WINNING_SCORE
  end

  def display_battle_outcome
    human.move.battle_outcome(computer)
    computer.move.battle_outcome(human)
  end

  def display_round_winner
    if human.move.beats(computer)
      puts "**** #{human.name} wins this round! ****"
    elsif computer.move.beats(human)
      puts "**** #{computer.name} wins this round! ****"
    else
      puts "****It's a tie!****"
    end
  end

  def display_round_outcome
    display_moves
    display_battle_outcome
    space
    display_round_winner
  end

  def keep_players_move_history
    computer.keep_move_history
    human.keep_move_history
  end

  def display_players_move_history
    space
    computer.display_move_history
    space
    human.display_move_history
    space
  end

  def play_round
    human.choose
    computer.choose
    display_round_outcome
    keep_score
    display_score
    keep_players_move_history
  end

  def display_game_winner
    space
    if computer.score == WINNING_SCORE
      winner = computer.name
    elsif human.score == WINNING_SCORE
      winner = human.name
    end
    puts "#{winner} wins the game with a score of #{WINNING_SCORE}"
  end

  def display_game_aborted
    puts "Game aborted! No winner!"
  end

  def play_another_game?
    answer = nil
    display_players_move_history
    loop do
      puts "Do you want to play another game? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry. Inalid entry!"
    end
    answer.downcase == 'y'
  end

  def reset_new_game
    reset_score
    reset_move_history
  end

  def play
    display_welcome_message
    loop do
      reset_new_game
      until winning_score_reached || !continue_playing?
        play_round
      end
      winning_score_reached ? display_game_winner : display_game_aborted
      break unless play_another_game?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
