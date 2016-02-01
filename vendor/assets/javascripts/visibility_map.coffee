(($) ->
  'use strict'  
  class GenericVisibilityChecker
    constructor: (element) ->
      @element = element
      @map = @element.data('visibility-map')
      @allFields = $($.unique $.map @map, (val) -> $(val).get())
  
    check: ->
        toShow = $ $.unique $.map @getValue(), (value) => $(@map[value]).get()
        toHide = @allFields.not(toShow)
      
        toShow.show()
        toShow.trigger('visibility.show')
        $(':input:not([data-visibility-map-no-auto-enable])', toShow).prop('disabled', false)
        
        toHide.hide()
        toHide.trigger('visibility.hide')
        $(':input', toHide).prop('disabled', true)
    
    getValue: ->
      $.makeArray(@element.val())
    
  class CheckboxVisibilityChecker extends GenericVisibilityChecker
    getValue: ->
      $.map $("input[type='checkbox'][name='#{@element.attr('name')}']:checked"), (inputElement) ->
        $(inputElement).val()
  
  $.fn.setVisibility = ->
    @each ->
      data = $(this).data('visibility-checker')
      unless data?
        checkerClass = if $(this).is("input[type='checkbox']") then CheckboxVisibilityChecker else GenericVisibilityChecker    
        $(this).data('visibility-checker', data = new checkerClass $(this))
      data.check()
    
  $ ->
    $('input[data-visibility-map]:checked, select[data-visibility-map]').setVisibility()
    
    $(document.body).on 'change', '[data-visibility-map]', (e) ->
      $(this).setVisibility()
) jQuery