require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "pry"
require "pry-remote"
require "yaml"
require "bcrypt"

get "/" do
  
  erb :index
end
