class Dashing.Chartbeat_Toppages extends Dashing.Widget

  constructor: ->
    super
    @observe 'toppages', (toppages) ->
      host = $(@node).attr('data-host')
      if toppages[host]
        @set 'items', toppages[host]['items']

  ready: ->
    if @get('unordered')
      $(@node).find('ol').remove()
    else
      $(@node).find('ul').remove()
