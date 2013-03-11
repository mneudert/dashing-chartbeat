class Dashing.Chartbeat_People extends Dashing.Widget

  @accessor 'value', Dashing.AnimatedValue

  constructor: ->
    super
    @observe 'people', (people) ->
      host = $(@node).attr('data-host')
      if people[host]
        $(@node).find('.meter').trigger('configure', {max: people[host].max})
        $(@node).find('.meter').val(people[host].value).trigger('change')

  ready: ->
    meter = $(@node).find('.meter')
    meter.attr('data-bgcolor', meter.css('background-color'))
    meter.attr('data-fgcolor', meter.css('color'))
    meter.knob()
