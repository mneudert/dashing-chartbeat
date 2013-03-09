class Dashing.Peoplemeter extends Dashing.Widget

  @accessor 'value', Dashing.AnimatedValue

  constructor: ->
    super
    @observe 'value', (value) ->
      max_val = $(@node).find('.meter').attr('data-max')
      $(@node).find('.meter').trigger('configure', {max: max_val})
      $(@node).find('.meter').val(value).trigger('change')

  ready: ->
    meter = $(@node).find('.meter')
    meter.attr('data-bgcolor', meter.css('background-color'))
    meter.attr('data-fgcolor', meter.css('color'))
    meter.knob()
