class SearchesController < ApplicationController
  authorize_resource
  
  def index
    @questions = Question.search("#{params[:search]}")
  end
end
