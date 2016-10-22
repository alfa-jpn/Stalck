Stalcks.Vues.Pager =
  class Pager extends Stalcks.Vues.VueBase
    data:
      target: ''

    methods:
      onSubmit: (e) ->
        e.preventDefault()
        Turbolinks.visit("/#{encodeURIComponent(@target)}")
