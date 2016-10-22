Stalcks.Vues.Pager =
  class Pager extends Stalcks.Vues.VueBase
    data:
      type:    'user'
      keyword: ''

    methods:
      onSubmit: (e) ->
        e.preventDefault()
        Turbolinks.visit("/#{@type}/#{encodeURIComponent(@keyword)}") if @keyword != ''
