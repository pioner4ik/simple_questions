require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  describe "GET #index" do
    subject { get :index, params: { category: "all", search: "Search" } }

    it "call search method" do
      expect(Search).to receive(:detect_with_query).with("all", "Search")
      subject
    end

    it "render index view" do
      subject
      expect(response).to render_template :index
    end
  end
end
