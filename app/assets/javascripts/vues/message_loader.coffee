Stalcks.Vues.MessageLoader =
  class MessageLoader extends Stalcks.Vues.VueBase

    mounted: ->
      @updateMessages()

    data:
      messages: []

    methods:
      updateMessages: ->
        $.ajax("#{location.href}.json").done( (data) =>
          @messages = data.messages
        )
