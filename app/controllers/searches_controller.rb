class SearchesController < ApplicationController
  authorize_resource
  
  def index
    @category = (params[:category]).capitalize

    if @category == "All"
      @search = ThinkingSphinx.search(params[:search] + "*", page: params[:page] , per_page: 10)
    else
      @search = Object.const_get(@category).search(params[:search] + "*", page: params[:page] , per_page: 10)
    end
  end
end
