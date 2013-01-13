$(document).ready () ->
  $notice = $("#flash-notice")

  $notice.delay(3000).fadeOut () ->
    $notice.remove();