require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  describe "GET #index" do
    it "render index view" do
      get :index, params: { search: "Search" }
      expect(response).to render_template :index
    end
  end
end
