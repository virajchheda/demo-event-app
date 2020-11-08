$ ->
  $('.invite_user').click ->
    console.log($(this).data('event-id'))
    name = "#user-email-"+$(this).data('event-id')
    console.log(name)
    $email = $(name).val().replace(/\s/g,'')
    console.log($email)
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
      console.log($.parseJSON(data.responseText).msg)
      alert($.parseJSON(data.responseText).msg)


  
#$('.datetimepicker').datepicker();
#$('#datetimepicker1').datetimepicker();
  
