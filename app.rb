require 'sinatra'
require './models/mastermind.rb'
require './models/application_helper.rb'

class App < Sinatra::Base

  helpers ApplicationHelper

  configure do
    use Rack::Session::Pool
  end

  get '/' do
  	if session[:running].nil?
  		redirect to "/newgame"
  	end
    erb :index, :locals => {:input_state => session[:input_state],
                            :game_board => session[:html],
                            :game_result => session[:game_result]}
  end

  post '/' do
    #quick check if game has been over or if session was lost
    redirect to "/newgame" if session[:running] == false || session[:running].nil?
    #add input to the mastermind object and builds output
  	interpert_input params
    session[:game].build_feedback
    #setting the html up for the user
    input_selection params
  	build_html
    erb :index, :locals => {:input_state => session[:input_state],
                            :game_board => session[:html],
                            :game_result => session[:game_result]}

  end

  get '/newgame' do
  	#create a new game
    session[:game] = Mastermind.new()
  	session[:game_result] = ""
  	session[:html] = ""
  	session[:running] = true
    session[:input_state] = ["red","red","red","red"]
  	#redirect back to main page
  	redirect to "/"
  end
end

App.run!
