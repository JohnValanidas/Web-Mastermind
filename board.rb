class Board
  require "./Peg.rb"

  def initialize(board_length, code_length)
    @board_length = board_length
    @code_length = code_length
    @game_board = Array.new(board_length) {Array.new(code_length, " ")}
    @feedback = Array.new(board_length) {Array.new(code_length, " ")}
  end

  def empty_board
    @game_board = Array.new(@board_length) {Array.new(@code_length, " ")}
    @feedback = Array.new(@board_length) {Array.new(@code_length, " ")}
  end


  def add_ball(row, column, color)
    item = Peg.new()
    item.set_color(color)
    @game_board[row][column] = item
  end


  def add_peg(row, column, color)
    item = Peg.new()
    item.set_color(color)
    @feedback[row][column] = item
  end

  #returns a row with color values from each ball
  def get_ball_input(row)
    array = []
    (0..@code_length-1).each {|index| array.push(@game_board[row][index].get_color)}
    array
  end

  def get_peg_output
    array = []
    (0..@code_length-1).each {|index| array.push(@feedback[row][index].get_color)}
    array
  end

  def element_at(row, column)
    return @game_board[row][column]
  end

  private

  def string_builder (row, column, array, string="")
    element = array[row][column]
    element.is_a?(Peg) ? string += element.show + " ": string += element + " "
    string
  end
end
