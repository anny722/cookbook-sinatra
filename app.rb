require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "recipe"
require_relative "cookbook"
set :bind, '0.0.0.0'
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do
 cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
 @recipes = cookbook.all
 erb :index
end


get '/new' do
erb :new
end

post '/recipes' do
 name = params[:name]
 description = params[:description]
 recipe = Recipe.new(name, description)
 cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
 cookbook.add_recipe(recipe)
 @recipes = cookbook.all
 erb :index
end

get '/destroy' do
index = params[:index].to_i
cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
cookbook.remove_recipe(index)
@recipes = cookbook.all
erb :index
end
