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

def file_path(filename)
  File.expand_path("../#{filename}", __FILE__) 
end

def load_users
  path = File.expand_path("../users.yml", __FILE__) 
  YAML.load_file(path)
end

def username_exist?(username)
  data = load_users
  data.has_key?(username) ? true : false
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
  credentials = load_users

  if credentials.key?(username) && credentials[username][:password] == password
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

post "/users/signout" do
  session.delete(:username)
  session[:message] = "You have been signed out."
  redirect "/users/signin"
end

post "/users/signup" do
  username = params[:email]
  password = params[:password]
  confirm_password = params[:confirm]
  data = load_users
  if username_exist?(username)
    session[:message] = "Konto o podanym loginie istnieje"
    redirect "/users/sign_in"
  elsif password != confirm_password
    session[:message] = "Podane hasła nie pasują"
    erb :sign_in, layou: :layout
    redirect "/users/sign_in"
  else
    data[username] = {password: password}
    output = YAML.dump(data)
    File.write(file_path("users.yml"), output)
    session[:message] = "Twoje konto zostało utworzone"
    redirect "/users/home"
  end
 end
