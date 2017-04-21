class Mastermind

  attr_accessor :feedback, :input, :turns, :code

  def initialize
    @colors = ["red","blue","green",
               "orange","purple","pink"]
    reset
  end

  def reset
    @code = random_code
    @input = []
    @feedback = []
    @turns = 0
  end

  def build_feedback
    #builds feedback for the LAST inputed values
    feedback = []
    input = @input[-1].dup #latest input
    input.each_with_index do |color, index|
      if color == @code[index]
        feedback.push("black")
      end
    end
    index = 0
    total = 0
    while index < input.length
      # How many times does a color appear
      code_repition = @code.count(input[index])
      input_repition = input.count(input[index])
      if code_repition > 0
        input.delete(input[index])
        input_repition < code_repition ? total += input_repition : total += code_repition
      else
        index += 1
      end
    end
    exact_count = feedback.length
    while exact_count < total
      feedback.push("grey")
      exact_count += 1
    end
    @feedback.push(feedback)
  end

  def random_code
    return [@colors[rand(6)],
            @colors[rand(6)],
            @colors[rand(6)],
            @colors[rand(6)]]
  end

  def game_over?
    if @turns >= 1
      if @input[-1] == @code
        return "win"
      end
      if @turns >= 12
        return "loss"
      end
    else
      return false
    end
  end

end
