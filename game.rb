require 'sinatra'
require 'sinatra/reloader'

enable :sessions
@@input = []
@@feedback = []
@@html = ""
@@started = false;
@@colors = ["red","blue","green","orange","purple","pink"]
@@code = ["red","blue","red","red"]
@@turns = 0;


def build_html
  row = "<li class=\"turn-row\">" + "\n"
  build_html_input(row)
  build_html_feedback(row)
  row << "</li>" + "\n"
  @@html = row << @@html

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

def interpert_input params
  @@input.push([params['selection_1'].to_s,
               params['selection_2'].to_s,
               params['selection_3'].to_s,
               params['selection_4'].to_s])
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

get '/' do
  erb :index, :locals => {:game_board => @@html}
end

post '/' do
  @@turns += 1
  interpert_input(params)
  build_feedback
  build_html
  erb :index, :locals => {:game_board => @@html}
end
