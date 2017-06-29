require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
require "tilt/erubis"
require "pry"
require "pry-remote"
require "yaml"
require "bcrypt"
require 'date'

configure do
  enable :sessions # tells sinatra to enable a sessions support
  set :session_secret, 'secret' # setting session secret, for production this should be something longer and not straightforward in the code
end

helpers do
  def validate_wod(wod)
    if wod == nil
      session[:message] = "We didn't have WOD that day yet"
    else
      wod
    end
  end

  def show_wod(year, month, day)
    path = file_path("workouts.yml")
    data = YAML.load_file(path)
    date = Time.new(year, month, day)
    output = data[date.year][date.month][date.day]

    validate_wod(output)
  end

  def today_wod
    today = Time.new
    show_wod(today.year, today.month, today.day)
  end

  def show_max_result(exercise)
    data = load_users
    if exercise == nil
      "Not register"
    else
      data[session[:username]][exercise]
    end
  end

end

def file_path(filename)
  File.expand_path("../data/#{filename}", __FILE__)
end

def load_users
  path = file_path("users.yml")
  YAML.load_file(path)
end

def load_file(filename)
  path = file_path(filename)
  YAML.load_file(path)
end

def username_exist?(username)
  data = load_users
  data.has_key?(username) ? true : false
end

def admin?
  data = load_users
  if data[session[:username]][:admin] != nil
    true
  else
    false
  end
end

def parse_wod_params(date)
  @date = date.split("-")
  year = @date[0].to_i
  month= @date[1].to_i
  day = @date[2].to_i
  [year, month, day]
end

get "/" do

  erb :index, layout: false
end

get "/users/signin" do
  if session[:username]
    redirect "/users/home"
  end
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
    session[:error] = "Invalid credentials"
    status 422
    erb :sign_in
  end
end

get "/users/home" do
  erb :user_homepage, layout: :layout2
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
    session[:error] = "Konto o podanym loginie już istnieje"
    redirect "/users/signin"
  elsif password != confirm_password
    session[:error] = "Podane hasła nie pasują"
    erb :sign_in, layou: :layout
    redirect "/users/signin"
  else
    data[username] = {password: password}
    output = YAML.dump(data)
    File.write(file_path("users.yml"), output)
    session[:success] = "Twoje konto zostało utworzone"
    redirect "/users/home"
  end
 end

 get "/wods/:id" do
   @date = parse_wod_params(params[:id])
  erb :wods, layout: :layout2
 end

get "/wods" do
  redirect "/users/home"
end

 post "/wods" do
  @wod_id = params[:wod]

  redirect "/wods/#{@wod_id}"
 end

get "/users/personal_records" do
  erb :personal_records, layout: :layout2
end

get "/users/personal_records/edit" do
  erb :edit_record, layout: :layout2
end

post  "/users/personal_records" do
  @exercise = params[:exercise]
  @max_result = params[:max_result]
  @username = session[:username]
  data = load_users
  data[@username][@exercise] = @max_result
  output = YAML.dump(data)
  File.write(file_path("users.yml"), output)

  redirect "/users/personal_records"
end

get "/wods/edit/:id" do
  data = load_file("workouts.yml")
  @wod_id = params[:id]
  @wod_params = parse_wod_params(@wod_id)
  @content = data[@wod_params[0]][@wod_params[1]][@wod_params[2]]

  erb :edit_wod, layout: :layout2
end

post "/wods/edit/:id" do
  @wod_id = params[:id]
  @wod_params = parse_wod_params(@wod_id)
  data = load_file("workouts.yml")
  data[@wod_params[0]][@wod_params[1]][@wod_params[2]] = params[:content]
  output = YAML.dump(data)
  File.write(file_path("workouts.yml"), output)

  redirect "/wods/#{@wod_id}"
end

post "/wods/add" do
  @wod_id = params[:wod]
  redirect "/wods/edit/#{@wod_id}"
end
