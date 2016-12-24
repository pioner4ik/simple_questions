class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    social_network("Facebook")
  end

  def vkontakte
    social_network("Vkontakte")
  end

  private

    def social_network(data)
      @user = User.find_for_oauth(request.env['omniauth.auth'])
      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: data) if is_navigational_format?
      end
    end
end