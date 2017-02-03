class SearchesController < ApplicationController
  authorize_resource
  
  def index
    @category = (params[:category])
    @search = Search.detect_with_query(@category, params[:search])
    @search.search(page: params[:page], per_page: 10) if @search
  end
end
