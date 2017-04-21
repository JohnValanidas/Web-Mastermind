require 'sinatra'
require './models/mastermind.rb'

class App < Sinatra::Base

  @game = Mastermind.new()


  use Rack::Session::Pool


  get '/' do
  	if session[:running].nil?
  		redirect to "/newgame"
  	end
    erb :index, :locals => {:game_board => session[:html],
                            :game_result => session[:game_result]}
  end

  post '/' do
    redirect to "/newgame" if session[:running] == false
  	interpert_input params
  	session[:game].build_feedback
  	build_html
    erb :index, :locals => {:game_board => session[:html],
                            :game_result => session[:game_result]}

  end

  get '/newgame' do
  	#create a new game
    session[:game] = Mastermind.new()
  	session[:game_result] = ""
  	session[:html] = ""
  	session[:running] = true
  	#redirect back to main page
  	redirect to "/"
  end

  helpers do

  	def interpert_input params
  	     session[:game].input.push([params['selection_1'].to_s,
  	               			            params['selection_2'].to_s,
  	               			            params['selection_3'].to_s,
  	               			            params['selection_4'].to_s])
  	     session[:game].turns += 1
  	end


  	def build_html
  	  row = "<li class=\"turn-row\">" + "\n"
  	  build_html_input(row)
  	  build_html_feedback(row)
  	  row << "</li>" + "\n"
  	  session[:html] = row << session[:html]
      case session[:game].game_over?
        when "win"
          session[:running] = false
          build_html_win
        when "loss"
          session[:running] = false
          build_html_loss
      end
  	end

  	def build_html_input row
  	  row << "<ul class=\"input-row\">" + "\n"
  	  session[:game].input[-1].each do |color|
  	    row << "<li><div class=\"circle #{color}\"></div></li>" + "\n"
  	  end
  	  row << "</ul>" + "\n"
  	end

  	def build_html_feedback row
  	  row << "<ul class=\"feedback-row\">" + "\n"
  	  session[:game].feedback[-1].each do |color|
  	    row << "<li><div class=\"peg #{color}\"></div></li>" + "\n"
  	  end
  	  row << "</ul>" + "\n"
  	end

  	def build_html_win
  	  session[:game_result] << "<h1 class=\"game-result\">You've Won!</h1>" + "\n"
  	end

  	def build_html_loss
  	 session[:game_result] << "<h1 class=\"game-result\">You've Lost!</h1>" + "\n"
  	 session[:game_result] << "<ul class=\"secret-code\">" + "\n"
  	  session[:game].code.each do |color|
  	    session[:game_result] << "<li><div class=\"circle #{color}\"></div></li>" + "\n"
  	  end
  	  session[:game_result] << "</ul"> + "\n"
  	end

  end
end

App.run!
