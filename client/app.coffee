Template.body.rendered = ->
  $(".pjs-balloon-dialog").each ->
    $(this).qtip
      content:
        text: $(this).next()
      show: 'click'
      hide: 'unfocus'
      position:
        at: 'right center'
        my: 'left top'
        adjust:
          y: -10
      style:
        classes: 'qtip-bootstrap'
        tip:
          width: 16
          height: 8
          offset:  30
          mimic: 'left center'
