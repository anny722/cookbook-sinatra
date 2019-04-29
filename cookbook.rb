require 'csv'
class Cookbook
  attr_reader :cookbook, :recipes
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = []
    parse_csv
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    store_csv
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    store_csv
  end

  def mark_done(recipe_index)
    @recipes[recipe_index].done = true
    store_csv
  end

  def parse_csv
    CSV.foreach(@csv_file_path) do |recipe|
      @recipes << Recipe.new(recipe[0], recipe[1], recipe[2], recipe[3] == 'true')
    end
  end

  def store_csv
    CSV.open(@csv_file_path, "wb") do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.prep_time, recipe.done]
      end
    end
  end
end
