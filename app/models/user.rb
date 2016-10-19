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
    # IDからユーザを探す。
    # @return [User, Nil] ユーザ
    def find_by_id(id)
      dictionary[id]
    end

    private
    # ユーザ辞書
    # @return [Hash] ユーザ辞書
    def dictionary
      Rails.cache.fetch('User.dictionary', expires_in: 1.minutes) do
        all.map { |user| [user.id, user] }.to_h
      end
    end
  end
end
