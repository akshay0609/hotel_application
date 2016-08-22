$(document).ready(function(){
  booking_date()
  
  if ($('#room_name').text() != "") {
    var curent_date = new Date()
    room_available_ajax_call($('#booking_check_in').val(),$('#booking_check_out').val(),$('#room_name').text())  
  }

    $('.closed').on('click',function(){
        var effect = $(this).data('effect');
        $(this).closest('.panel')[effect]();
    })

    $('#bookings').dataTable()
})

function booking_date(){
  $('#booking_check_in').datepicker({
    dateFormat: 'yy-mm-dd',
    numberOfMonths: 1,
    minDate: new Date(),
    maxDate: "+6m",
    autoclose: true,
    onSelect: function(date) {
      room_available_ajax_call(date,$('#booking_check_out').val(),$('#room_name').text());
     }
  });
  
  $('#booking_check_out').datepicker({
    dateFormat: 'yy-mm-dd',
    numberOfMonths: 1,
    minDate: new Date(),
    maxDate: "+6m",
    onSelect: function(date) {
       room_available_ajax_call($('#booking_check_in').val(),date,$('#room_name').text());
     }
  });
  
  $("#booking_check_in").datepicker("setDate", new Date());
  $("#booking_check_out").datepicker("setDate", new Date());

}

function room_available_ajax_call(arrive,departure,room_type){
  $('#select_rooms').empty()
  $.ajax({
        method: "POST",
        url: '/bookings/available_rooms',
        data: {booking_dates: {check_in: arrive,check_out: departure, room_type: room_type}},
        success: function(data) {
            for(var room=0; room<data.length; room++) {
              $('#select_rooms').append("<input type='checkbox' name='booking[room_ids][]' id='room"+ room + "' value=\'" + data[room].room_id + "\'> ")
              $('#select_rooms').append("<label class='room_lable' for='room"+ room +"'>" + data[room].room_id + "</label>  ")
            }
            hide_spinner();
        },
        beforeSend: function() {
          show_spinner();
        },
        error: function(jqXHR, textStatus, errorThrown) {
          $('#select_rooms').append("<span class='text-center'>Internal Error please try can some time later</spna>")   
          console.log(textStatus, errorThrown);
          hide_spinner();
        }
    })
}

$.urlParam = function(name){
	var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
	return results[1] || 0;
}