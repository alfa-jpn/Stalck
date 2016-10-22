Rails.application.routes.draw do
  root controller: :messages, action: :index
  get '/:target', controller: :messages, action: :show
end
