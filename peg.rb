class Peg

  require 'colorize'

  def initialize(normal = true)
    @color = "white"

  end

  def set_color(color)
    @color = color
    @content = @content.colorize(color.to_sym)
  end

  def get_color
    @color
  end


  def show
    @content
  end

end
