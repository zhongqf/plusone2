Template.body.rendered = ->
  $(".text-multiline-ellipsis").dotdotdot()

  setScrollbarStyle = ->
    $(".scrollable").each ->
      if (this.scrollHeight > this.offsetHeight)
        $(this).addClass("has-scrollbar")

  $(window).resize -> setScrollbarStyle()


  setScrollbarStyle()

