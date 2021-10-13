class RecipesController < ApplicationController
before_action :authorize
  


    def index
        recipes = Recipe.all
        render json: recipes, include: :user   
    end

    def create
        user = User.find_by(id: session[:user_id])
        recipe = user.recipes.create!(recipe_params)
        render json: recipe, status: :created, include: :user
    
    rescue ActiveRecord::RecordInvalid => invalid
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end 

    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end 

    def authorize

        return render json: { errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id 
      
    end

end
