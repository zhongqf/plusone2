Template.body.rendered = ->
  #$(".text-multiline-ellipsis").dotdotdot()

  #setScrollbarStyle = ->
  #  $(".scrollable").each ->
  #    if (this.scrollHeight > this.offsetHeight)
  #      $(this).addClass("has-scrollbar")

  #$(window).resize -> setScrollbarStyle()


  #setScrollbarStyle()



  $("[data-toggle=tooltip]").tooltip({container: 'body'})
  
  #popover
  $("[data-toggle=popover]").popover()

  $(document).on 'click', '.popover-title .close', (e)->
    $target = $(e.target)
    $popover = $target.closest('.popover').prev()
    $popover && $popover.popover('hide')



Template.body.created =->
