class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    authenticate_with_provider
  end

  def apple
    authenticate_with_provider
  end

  def failure
    redirect_to new_user_session_path, alert: "Não foi possível entrar com essa conta. Tente novamente."
  end

  private

  def authenticate_with_provider
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      redirect_to new_user_session_path, alert: "Não foi possível autenticar sua conta."
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to new_user_registration_path, alert: "Não recebemos um e-mail válido dessa conta. Tente outro método."
  end
end
