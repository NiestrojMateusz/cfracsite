require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
require "tilt/erubis"
require "pry"
require "pry-remote"
require "yaml"
require "bcrypt"

get "/" do
  
  erb :index, layout: :layout
end

get "/sign_in" do

  erb :sign_in, layout: :layout
end
