module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:facebook] =  OmniAuth::AuthHash.new({
      :provider =>'facebook',
      :uid => '123456'})
  end
end