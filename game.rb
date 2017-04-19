require 'sinatra'
require 'sinatra/reloader'

enable :sessions
@@colors = ["red","blue","green","orange","purple","pink"]
@@code = ["red","blue","red","red"]


def random_code
  return [@@colors[rand(6)],@@colors[rand(6)],@@colors[rand(6)],@@colors[rand(6)]]
end

def build_html
  row = "<li class=\"turn-row\">" + "\n"
  build_html_input(row)
  build_html_feedback(row)
  row << "</li>" + "\n"
  @@html = row << @@html
  game_over?
end

def reset
  @@turns = 0
  @@input = []
  @@feedback = []
  @@html = ""
  @@game_result = ""
  @@code = random_code
end

def run params
  reset if @@turns == 12
  @@turns += 1
  interpert_input(params)
  build_feedback
  build_html
end

def build_html_input row
  row << "<ul class=\"input-row\">" + "\n"
  @@input[-1].each do |color|
    row << "<li><div class=\"circle #{color}\"></div></li>" + "\n"
  end
  row << "</ul>" + "\n"
end

def build_html_feedback row
  row << "<ul class=\"feedback-row\">" + "\n"
  @@feedback[-1].each do |color|
    row << "<li><div class=\"peg #{color}\"></div></li>" + "\n"
  end
  row << "</ul>" + "\n"
end

def build_html_win
  @@game_result << "<h1 class=\"game-result\">You've Won!</h1>" + "\n"
end

def build_html_loss
  @@game_result << "<h1 class=\"game-result\">You've Lost!</h1>" + "\n"
  @@game_result << "<ul class=\"secret-code\">" + "\n"
  @@code.each do |color|
    @@game_result << "<li><div class=\"circle #{color}\"></div></li>" + "\n"
  end
  @@game_result << "</ul"> + "\n"
end

def interpert_input params
  @@input.push([params['selection_1'].to_s,
               params['selection_2'].to_s,
               params['selection_3'].to_s,
               params['selection_4'].to_s])
end

def game_over?
  if @@turns >= 1
    if @@input[-1] == @@code
      build_html_win
      return
    end
    if @@turns == 12
      build_html_loss
    end
  end
end

def build_feedback
  #builds feedback for the LAST inputed values
  feedback = []
  input = @@input[-1].dup #latest input
  input.each_with_index do |color, index|
    if color == @@code[index]
      feedback.push("black")
    end
  end
  index = 0
  total = 0
  while index < input.length
    # How many times does a color appear
    code_repition = @@code.count(input[index])
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
  @@feedback.push(feedback)
end



# actual server
reset
get '/' do
  erb :index, :locals => {:game_board => @@html,
                          :game_result => @@game_result}
end

post '/' do
  run params
  erb :index, :locals => {:game_board => @@html,
                          :game_result => @@game_result}
end
