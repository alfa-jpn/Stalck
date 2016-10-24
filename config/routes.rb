Rails.application.routes.draw do
  root controller: :messages, action: :index
  get  '/slack_callback',       controller: :messages, action: :registration_token,                                as: :oauth_callback
  get  '/slack_login_callback', controller: :sessions, action: :login,                                             as: :oauth_login_callback
  get  '/sign_out',             controller: :sessions, action: :logout,                                            as: :sign_out
  get  '/:type(/:keyword)',     controller: :messages, action: :show, constraints: { type: /(all|user|message)/ }, as: :show
  post '/messages',             controller: :messages, action: :create
end
