FactoryGirl.define do
  factory :attachment do
    file { Rack::Test::UploadedFile.new(File.open("#{Rails.root}/README.md"))}
    attachable nil
  end
end
