class Bot
  include Concerns::Models::SlackAdapter

  column :id
  column :deleted
  column :name
  column :icons

  api_singleton_method :find, 'bots.info', :bot, collection: false

  class << self
    # Find bot by id.
    # @return [User, Nil] bot
    def find_by_id(id)
      find(bot: id)
    end
  end
end
