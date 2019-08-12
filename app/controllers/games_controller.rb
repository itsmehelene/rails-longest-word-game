require 'open-uri'
class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
    session[:grid] = @letters.join
  end

  def score
    if presence_in_grid
      request_api
    else 'sorry'
    end
  end

  private

  def generate_grid(grid_size)
    grid = []
    grid_size.times { grid << ('A'..'Z').to_a.sample }
    return grid
  end

  def presence_in_grid
    grid = session[:grid]
    params[:name].split('').each do |letter|
      if grid.include? letter
        grid.delete_at(grid.index(letter))
      else
        false
      end
    end
  end

  def request_api
    api_result = open("https://wagon-dictionary.herokuapp.com/#{params[:name]}").read
    autre_result = JSON.parse(api_result)

    if autre_result['found'] == true
      @truc = "Congratulation! #{params[:name]} is a valid english word"
    else
      @truc = "Sorry but #{params[:name]} doesn't seem to be an english word"
    end
  end
end
