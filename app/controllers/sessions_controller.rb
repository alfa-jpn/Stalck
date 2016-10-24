class SessionsController < ApplicationController
  # GET /slack_login_callback
  def login
    auth = OAuth.find(
      client_id:     Stalck.config.slack.client_id,
      client_secret: Stalck.config.slack.client_secret_key,
      code:          params['code'],
      redirect_uri:  oauth_login_callback_url
    )

    if auth.team_id == Stalck.config.slack.team_id
      session[:user_id] = auth.user_id
      redirect_to root_path
    else
      raise "#{auth.team_name} is not permitted team."
    end
  end

  # GET /sign_out
  def logout
    reset_session
    redirect_to root_path
  end
end
