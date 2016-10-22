class MessagesController < ApplicationController
  before_action :set_keyword, only: [:show]
  before_action :set_type,    only: [:show]

  def index
  end

  def show
    respond_to do |format|
      format.json do
        MessageSearcher.search(query: @type.create_query(@keyword), sort: :timestamp).tap do |result|
          @messages = result.messages
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
    @keyword = params[:keyword]
  end

  def set_type
    @type = MessageSearchers::Type.parse!(params[:type])
  end
end
