# frozen_string_literal: true

require_relative './chess_game'

def new_game_or_load
  user_input = nil
  until %w[y n].include?(user_input)
    puts 'Load saved game? y / n'
    user_input = gets.chomp
    if user_input == 'y'
      loaded_game = open('chess_game.yaml', 'r') { |f| YAML.load_file(f) }
      loaded_game.play
    elsif user_input == 'n'
      new_game = ChessGame.new
      new_game.play
    end
  end
end

new_game_or_load
