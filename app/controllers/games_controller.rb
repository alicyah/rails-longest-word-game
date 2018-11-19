require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = []
    10.times do
      @grid << ("A".."Z").to_a.sample
    end
    return @grid
  end

  def score
    @result = run_game(params[:combination], params[:grid])
  end

  def array_to_hash(array)
    hash = {}
    array.each do |letter|
      hash[letter] = array.count(letter)
    end
    return hash
  end

  def run_game(combination, grid)
    api = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{combination}").read)
    grid_array = grid.delete(" ").split(//)
    combination_array = combination.upcase.split(//)
    grid_hash = array_to_hash(grid_array)
    combination_hash = array_to_hash(combination_array)
    valid_attempt = true
    combination_hash.each do |letter, id|
      valid_attempt = false unless grid_hash.key?(letter) && id <= grid_hash[letter]
    end
    validity(api, valid_attempt, combination, grid_array)
  end

  def validity(api, valid_attempt, combination, grid_array)
    grid_to_string = grid_array.join(', ')
    if valid_attempt == false
      return "Sorry but #{combination.upcase} can't be built out with #{grid_to_string}"
    elsif api["found"] == false
      return "Sorry but #{combination.upcase} does not seem to be a valid English word..."
    else
      return "Congratulations! #{combination.upcase} is a valid English word!"
    end
  end
end

