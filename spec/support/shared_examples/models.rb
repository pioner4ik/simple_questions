require "rails_helper"

RSpec.shared_examples "attachable" do 
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }
end

RSpec.shared_examples "commentable" do 
  it { should have_many(:attachments).dependent(:destroy) }
end

RSpec.shared_examples "votable" do 
  it { should have_many(:votes).dependent(:destroy) }
end