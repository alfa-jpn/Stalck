Stalcks.Vues.MessageLoader =
  class MessageLoader extends Stalcks.Vues.VueBase
    mounted: ->
      @messages  = JSON.parse(@$el.dataset.messages)['messages']
      @keywords  = @$el.dataset.keyword?.split(' ')
      @type      = @$el.dataset.type
      @timestamp = @messages[0]?.timestamp || 0
      @updateMessages()

    data:
      messages:  []
      keywords:  ''
      type:      ''
      timestamp: 0

    methods:
      updateMessages: ->
        @clearMessageType()
        $.ajax("#{location.href}.json").done( (data) =>
          return if data.messages.length < 1

          for i in [(data.messages.length - 1)..0]
            message = data.messages[i]
            if @timestamp < message.timestamp
              @timestamp = message.timestamp
              if @type == 'all' || @isIncludingKeywords(message)
                message.type = 'newly'
                @messages.unshift(message)

          @messages = @messages.splice(0, 100)
        ).always( =>
          setTimeout(@updateMessages, 6000)
        )

      clearMessageType: ->
        message.type = '' for message in @messages

      isIncludingKeywords: (message) ->
        if @type == 'user'
          for user in @keywords
            return true if message.user_name == user
        else
          for keyword in @keywords
            console.log(message.text)
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
