class MessagesController < ApplicationController
  before_action :set_keyword, only: [:show]
  before_action :set_type,    only: [:show]
  before_action :set_histories

  HISTORY_CACHE_KEY = 'Views::Keywords::History'

  def index

  end

  def show
    respond_to do |format|
      format.json do
        MessageSearcher.search(query: 'after:yesterday', sort: :timestamp, count: 100).tap do |result|
          render 'messages/_partials/_messages', locals: { messages: result.messages }
        end
      end
      format.html do
        if @type.present? and @keyword.present?
          MessageSearcher.search(query: @type.create_query(@keyword), sort: :timestamp).tap do |result|
            @messages = result.messages
            if @messages.any? and @histories.none? { |h| h[:type] == @type.downcase and h[:keyword] == @keyword }
              Rails.cache.write(HISTORY_CACHE_KEY, @histories.unshift({ type: @type.downcase, keyword: @keyword }).take(50))
            end
          end
        else
          MessageSearcher.search(query: 'after:yesterday', sort: :timestamp, count: 20).tap do |result|
            @messages = result.messages
          end
        end
      end
    end
  end

  private
  # Set `@keyword`
  def set_keyword
    @keyword = params[:keyword].try(:strip)
  end

  # Set `@histories`
  def set_histories
    @histories = Rails.cache.read(HISTORY_CACHE_KEY) || []
  end

  def set_type
    @type = MessageSearchers::Type.parse(params[:type])
  end
end
