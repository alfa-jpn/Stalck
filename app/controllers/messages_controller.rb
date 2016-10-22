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
        MessageSearcher.search(query: @type.create_query(@keyword), sort: :timestamp).tap do |result|
          @messages = result.messages
          if @messages.any? and @histories.none? { |h| h[:type] == @type.downcase and h[:keyword] == @keyword }
            Rails.cache.write(HISTORY_CACHE_KEY, @histories.unshift({ type: @type.downcase, keyword: @keyword }).take(50))
          end
        end
      end
      format.html do
        render
      end
    end
  end

  private
  # Set `@keyword`
  def set_keyword
    @keyword = params[:keyword].strip
  end

  # Set `@histories`
  def set_histories
    @histories = Rails.cache.read(HISTORY_CACHE_KEY) || []
  end

  def set_type
    @type = MessageSearchers::Type.parse!(params[:type])
  end
end
