Stalcks.Vues.VueBase =
  class VueBase
    constructor: (@el) ->
      @data = JSON.parse(JSON.stringify(@data)) # copy data.
