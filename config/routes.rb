Rails.application.routes.draw do
  root controller: :messages, action: :index
  get '/:type(/:keyword)', controller: :messages, action: :show, constraints: { type: /(all|user|message)/ }, as: :show
end
