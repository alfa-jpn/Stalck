class User
  include Concerns::Models::SlackAdapter

  column :id
  column :team_id
  column :name
  column :deleted
  column :status
  column :color
  column :real_name
  column :tz
  column :tz_label
  column :tz_offset
  column :profile

  api_singleton_method :all, 'users.list', :members
end
