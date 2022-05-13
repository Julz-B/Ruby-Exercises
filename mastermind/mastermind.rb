# mastermind.rb

module Mastermind

  class Game

    def initialize
      @code_options = %w[B G O R W Y]  
      @guesses = Array.new
      @result_array = Array.new
      @solution = Array.new
      puts "---------- Mastermind ----------\n\n"
      puts " The Coder creates a code of 4 colours from the 6 available colour choices. Duplicate colours are allowed."
      puts " The Decoder has 12 attempts to crack the code using the evaluation from each each to aid the next guess."
      puts " Evaluation is provided in the form of Correct positions and Incorrect positions:"
      puts "\n Correct positions - Number of chosen colours that are included in the code and in the correct position."
      puts " Incorrect positions - Number of chosen colours that are included in the code but are in the wrong position." 
      puts "\n Should you chose to be the Coder, the computer will attempt to break your code.\n"
      puts "\n Good luck!!\n"
      print "\n Do you want to be the Coder or the Decoder? Respond with C for Coder or D for Decoder: "

      loop do # Assign the player as coder or decoder
        player_type = gets.chomp.upcase
        if player_type == "C" 
          @coder = Human.new(self)
          @decoder = Computer.new(self)
          return
        elsif player_type == "D"
          @coder = Computer.new(self)
          @decoder = Human.new(self)
          return
        end 
        puts "\nInvalid choice. Respond with C or D to continue."
      end

      puts "\nSelect 4 colours using the first letter of any of the available colours"
      puts "\nExample: GGRB => Green, Green, Red, Blue"
    end

    attr_reader :code_options, :guesses, :result_array, :solution

    def play
      solution

      loop do
        guesses_remaining
        next_guess       

        if solved?
          if @coder.class == Human 
            puts "\nThe computer cracked your code: #{guesses[-1]}\n"
            return
          else
            puts "\nCongratulations, you cracked the code!!! #{guesses[-1]} is correct!\n"
            return
          end
        elsif max_attempts_reached?
          if @coder.class == Human
            puts "\nCongratulations, the computer couldn't crack your code: #{@solution[-1]}\n" 
            return
          else  
            puts "\nSorry, you lose! The correct code was #{@solution}\n"
            return
          end
        end 

        show_guess_result
      end
    end

    def solution # Coder creates a code
      @solution = @coder.make_code
    end

    def guesses_remaining
      puts "\n#{12 - @guesses.count} guesses remaining."
    end

    def solved?
      @solution == @guesses[-1]
    end

    def max_attempts_reached?
      @guesses.count == 12
    end

    def next_guess
      guess = @decoder.make_guess
      if @coder.class == Human
        puts "\nThe computer guessed: #{guess}"
      else
        puts "\nYou guessed: #{guess}"
      end
      @guesses.push(guess)
    end

    def show_guess_result
      result = evaluate_guess
      @result_array.push(result)
      @guesses.each_with_index do |guess, idx|
        print "\tGuess #{idx + 1}: #{guess}\t|  Correct Positions: #{@result_array[idx][0]} | Incorrect Positions: #{@result_array[idx][1]}\n"
      end
    end

    def evaluate_guess # Find number of correct and incorrect positions 
      evaluation = [0, 0]
      @solution.each_index do |idx|
        if @solution[idx] == @guesses[-1][idx]
          evaluation[0] += 1
          idx += 1
        end
      end
      evaluation[1] = (@solution & @guesses[-1]).map { |colour| [@solution.count(colour), @guesses[-1].count(colour)].min }.reduce(:+)  
      if evaluation[1] == nil
        evaluation[1] = 0
      else
        evaluation[1] -= evaluation[0]
      end
      return evaluation
    end
  end

  class Human # < Player

    def initialize(game)
      @game = game
    end

    def make_guess 
      loop do
        puts "\nChoices: [B]lue, [G]reen, [O]range, [R]ed, [W]hite, [Y]ellow"
        print "\nMake your guess: "
        guess = gets.chomp.upcase.split("")
        return guess if guess.size == 4 && guess.all? { |colour| @game.code_options.include?(colour) } 
        puts "\nInvalid choice. Choose four colours using the first letter of each colour."
      end
    end

    def make_code
      loop do
        puts "\nCreate your super secret code of four colours."
        puts "\n[B]lue, [G]reen, [O]range, [R]ed, [W]hite, [Y]ellow"
        puts "\nDulpicate colours are allowed."
        print "\nYour code: "
        code = gets.chomp.upcase.split("")
        p code
        return code if code.size == 4 && code.all? { |colour| @game.code_options.include?(colour) } 
        puts "Invalid code selection. Choose four colours using the first letter of each colour."
      end
    end
  end

  class Computer # < Player

    def initialize(game)
      @game = game
      @base_colours = %w[BBBB GGGG OOOO RRRR WWWW YYYY]
      @solution_colours = Array.new # The colours included in the code
      @solution_options = Array.new # The possible combinations of solution_colours
    end

    def make_code
      code = []
      4.times do
        code.push(@game.code_options.sample)
      end
      return code
    end

    def make_guess
      unless found_colours_included? # Guess using base_colours until true to find colours in code.
        sleep 2
        return @base_colours.shift.split("")
      end
      if @solution_options.count == 0  
        find_included_colours 
        solution_options
        sleep 2
        return @solution_colours
      end

      remove_incorrect_options!
      sleep 2
      @solution_options.pop
    end 

    def solution_options # Populate @solution_options with all possible code combos.
      @solution_options = @solution_colours.permutation(4).to_a.uniq
    end

    def find_included_colours # populate @solution_colours
      @game.result_array.each_with_index do |result, idx|
        if result[0] > 0
          result[0].times do
            @solution_colours << @game.guesses[idx][0] 
          end
        end
      end
    end

    def found_colours_included?
      if @solution_colours.count == 4
        return true
      else 
        count_array = @game.result_array.transpose.map(&:sum)
        count_array[0] == 4
      end
    end

    def remove_incorrect_options! # Remove any code choices from @solution_options after each guess based on number of correct_position matches.
      remaining_options = Array.new
      correct_positions = @game.result_array[-1][0]
      matches = 0
      @solution_options.each do |code|
        code.each_with_index do |colour, idx|
          if colour == @game.guesses[-1][idx]
            matches += 1
          end
        end
        if matches <= correct_positions
          remaining_options << code
        end
        matches = 0
      end
      @solution_options = remaining_options
    end
  end
end

include Mastermind

# Game.new(Computer, Human).play

Game.new.play
