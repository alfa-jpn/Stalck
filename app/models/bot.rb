class Bot
  include Concerns::Models::SlackAdapter

  column :id
  column :deleted
  column :name
  column :icons

  api_singleton_method :find, 'bots.info', :bot, collection: false

  class << self
    # IDからボットを探す。
    # @return [User, Nil] ボット
    def find_by_id(id)
      find(bot: id)
    end
  end
end
