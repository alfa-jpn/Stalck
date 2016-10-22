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

  class << self
    # Find user by id.
    # @return [User, Nil] user
    def find_by_id(id)
      dictionary[id]
    end

    private
    # User dictionary.
    # @return [Hash] dictionary.
    def dictionary
      Rails.cache.fetch('User.dictionary', expires_in: 5.minutes) do
        all.map { |user| [user.id, user] }.to_h
      end
    end
  end
end
