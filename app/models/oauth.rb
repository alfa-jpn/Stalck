class OAuth
  include Concerns::Models::SlackAdapter

  column :access_token
  column :scope
  column :team_name
  column :team_id
  column :user_id

  api_singleton_method :find, 'oauth.access', nil, collection: false
end
