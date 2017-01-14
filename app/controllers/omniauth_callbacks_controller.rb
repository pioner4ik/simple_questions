class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    social_network("Facebook")
  end

  def vkontakte
    social_network("Vkontakte")
  end

  private

    def social_network(data)
      auth = request.env['omniauth.auth']
      @user = User.find_for_oauth(auth)
      if @user
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: data.capitalize) if is_navigational_format?
      else
        session["devise.auth_data"] = { provider: auth.provider, uid: auth.uid }
        redirect_to new_user_path
      end
    end
end