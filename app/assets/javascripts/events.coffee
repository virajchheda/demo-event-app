$ ->
  $('.invite_user').click ->
    name = "#user-email-"+$(this).data('event-id')
    $email = $(name).val().replace(/\s/g,'')
    $(name).val('')
    $.ajax(createInvite($(this).data('event-id'), $email))


  createInvite = (event_id, user_email) ->
    type: 'post'
    data:
      event_id: event_id
      user_email: user_email
    url: '/invites/create_invites'
    success: (data)  ->
      alert(data.msg)
      window.location.reload()
    error: (data) ->
      alert($.parseJSON(data.responseText).msg)

