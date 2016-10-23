Stalcks.Vues.MessageLoader =
  class MessageLoader extends Stalcks.Vues.VueBase
    mounted: ->
      @messages  = JSON.parse(@$el.dataset.messages)['messages']
      @keywords  = @$el.dataset.keyword?.split(' ')
      @type      = @$el.dataset.type
      @updateMessages()

    data:
      messages:  []
      keywords:  ''
      type:      ''

    computed:
      currentlyTimestamp: ->
        parseFloat(@messages[0]?.timestamp || 0)

    methods:
      updateMessages: ->
        @clearMessageType()
        timestamp =  parseFloat(@messages[0]?.timestamp || 0)

        $.ajax(url: "/all.json", method: 'get', data: { timestamp: @currentlyTimestamp }).done( (data) =>
          return if data.messages.length < 1

          for i in [(data.messages.length - 1)..0]
            message   = data.messages[i]
            if @currentlyTimestamp < parseFloat(message.timestamp || 0)
              if @type == 'all' || @isIncludingKeywords(message)
                message.type = 'newly'
                @messages.unshift(message)

          @messages.splice(100, data.messages.length)
        ).always( =>
          setTimeout(@updateMessages, 5500)
        )

      clearMessageType: ->
        for message in @messages
          message.type = '' if message.type != ''

      isIncludingKeywords: (message) ->
        if @type == 'user'
          for user in @keywords
            return true if message.user_name == user
        else
          for keyword in @keywords
            return true if @isIncludingKeyword(message.text, keyword)
            for attachment in message.attachments
              return true if @isIncludingKeyword(attachment.title,       keyword)
              return true if @isIncludingKeyword(attachment.text,        keyword)
              return true if @isIncludingKeyword(attachment.author_name, keyword)
              for field in attachment.fields
                return true if @isIncludingKeyword(field.title, keyword)
                return true if @isIncludingKeyword(field.value, keyword)
        return false

      isIncludingKeyword: (target, text) ->
        target && target.indexOf(text) != -1
