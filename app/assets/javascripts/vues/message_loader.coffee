Stalcks.Vues.MessageLoader =
  class MessageLoader extends Stalcks.Vues.VueBase

    mounted: ->
      @target = @$el.dataset.target
      @updateMessages()

    data:
      messages: [
        {
          icon: '',
          date: '2016/10/05 19:00:12',
          content: 'やほお'
        },
        {
          icon: '',
          date: '2016/10/06 19:00:12',
          content: 'やほほ2'
        }
      ]

    methods:
      updateMessages: ->
        $.ajax("#{location.href}.json").done( (data) =>
          @messages = data.messages
        )
