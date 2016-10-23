Stalcks.Vues.MessageLoader =
  class MessageLoader extends Stalcks.Vues.VueBase
    ready: ->
      @messages  = JSON.parse(@$el.dataset.messages)['messages']
      @keywords  = @$el.dataset.keyword?.split(' ')
      @type      = @$el.dataset.type
      @timestamp = parseFloat(@messages[0]?.timestamp || 0)
      @updateMessages()

    data:
      messages:  []
      keywords:  ''
      type:      ''
      timestamp: 0

    methods:
      updateMessages: ->
        return unless document.body.contains(@$el)
        @clearMessageType()

        $.ajax(url: "/all.json", method: 'get', data: { timestamp: @timestamp }).done( (data) =>
          return if data.messages.length < 1
          @timestamp = parseFloat(data.messages[0].timestamp || 0)
          @messages  = @filterMessages(data.messages).concat(@messages).splice(0, 100)
        ).always( =>
          setTimeout(@updateMessages, 5500)
        )

      clearMessageType: ->
        for message in @messages
          message.type = '' if message.type != ''

      filterMessages: (messages) ->
        filteredMessages = []

        for message in messages
          if @type == 'all' || @isIncludingKeywords(message)
            message.type = 'newly'
            filteredMessages.push(message)

        filteredMessages

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
