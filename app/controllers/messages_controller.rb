class MessagesController < ApplicationController
  before_action :set_target, only: [:show]

  def index
  end

  def show
    respond_to do |format|
      format.json do
        MessageSearcher.search(query: @target, sort: :timestamp).tap do |result|
          @messages = result.messages
        end
      end
      format.html do
        render
      end
    end
  end

  private

  # Set `@target`
  def set_target
    @target = params[:target]
  end

  def set_type
    @type =
  end
end
