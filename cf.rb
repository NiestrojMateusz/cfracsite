require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
require "tilt/erubis"
require "pry"
require "pry-remote"
require "yaml"
require "bcrypt"

configure do
  enable :sessions # tells sinatra to enable a sessions support
  set :session_secret, 'secret' # setting session secret, for production this should be something longer and not straightforward in the code
end

get "/" do

  erb :index, layout: :layout
end

get "/users/signin" do

  erb :sign_in, layout: :layout
end

post "/users/signin" do
  username = params[:username]
  password = params[:password]
  credentials = YAML.load_file(File.expand_path("../users.yml", __FILE__))

  if credentials.key?(username) && credentials[username] == password
    session[:username] = username
    session[:message] = "Witaj, #{username}"

    redirect "/users/home"
    else
    session[:message] = "Invalid credentials"
    status 422
    erb :sign_in, layout: :layout
  end
end

get "/users/home" do
  erb :user_homepage, layout: :layout
end
