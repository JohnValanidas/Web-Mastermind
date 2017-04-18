require 'sinatra'
require 'sinatra/reloader'

enable :sessions

def build_feedback

end

def build_input
end

get '/' do
  erb :index
end
