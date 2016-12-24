module OmniauthMacros
  def mock_auth_hash

    OmniAuth.config.mock_auth[:facebook] =  OmniAuth::AuthHash.new({
      :provider =>'facebook',
      :uid => '123456'})

    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
      :provider => 'vkontakte',
      :uid => '123456'
    })

  end
end