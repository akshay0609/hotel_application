var room_selected = [];
var room_price = 0;
var room_checked_count = 0
var check_out_date = ""

/*Initialize functions*/
$(document).ready(function(){
    initialize()
})

/*
* initialize datepicker and select event call ajax
**/
function booking_date(){
  var today = new Date();
  var tomorrow = new Date(today);
  tomorrow.setDate(today.getDate()+1);
  tomorrow.toLocaleDateString();

  $('#booking_check_in').datepicker({
    dateFormat: 'yy-mm-dd',
    numberOfMonths: 1,
    minDate: today,
    maxDate: "+6m",
    autoclose: true,
    onSelect: function(date) {
      room_available_ajax_call(date,$('#booking_check_out').val(),$('#room_name').text());
     }
  });

  $('#booking_check_out').datepicker({
    dateFormat: 'yy-mm-dd',
    numberOfMonths: 1,
    minDate: today,
    maxDate: "+6m",
    onSelect: function(date) {
       if ($('#booking_check_in').val() > date ) {
           $(this).val(check_out_date)
           alert("Departure Date must be higher than Arrival date")
       } else {
           room_available_ajax_call($('#booking_check_in').val(),date,$('#room_name').text());
       }
     }
  });
}

/*
* ajax for rooms availables
*/
function room_available_ajax_call(arrive,departure,room_type){
  $('#select_rooms').empty()
  $.ajax({
    method: "POST",
    url: '/api/available_rooms',
    data: {check_in: arrive,check_out: departure, room_type: room_type},
    success: function(data) {
      room_price = data.amount;
      for(var room=0; room<data.available_rooms.length; room++) {
        var flag = 0;
        if(room_selected.length > 0){
          for(var index=0;index<room_selected.length;index++){
            if (room_selected[index] == data.available_rooms[room].room_id){
              flag = 1;
            }
          }
         }
        if(flag == 0) {
          $('#select_rooms').append("<input type='checkbox' class='aa' name='booking[room_ids][]' id='room"+ room + "' value=\'" + data.available_rooms[room].room_id + "\'> ");
          $('#select_rooms').append("<label class='room_lable' for='room"+ room +"'>" + data.available_rooms[room].room_id + "</label>  ");
        }
      }
      room_checked_count = room_selected.length
      checkbox_click();
      price();
      hide_spinner();
    },
    beforeSend: function() {
      show_spinner();
    },
    error: function(jqXHR, textStatus, errorThrown) {
      $('#select_rooms').append("<span class='text-center'>Internal Error please try can after some time later</spna>")
      console.log(textStatus, errorThrown);
      hide_spinner();
    }
  });
}

/*
* find date difference for calculating bill
*/
function days_between(date1, date2) {
    date1 = new Date(date1+" 00:00:00");
    date2 = new Date(date2+" 24:00:00");

    var timeDiff = Math.abs(date2.getTime() - date1.getTime());
    var timeDifferenceInDays = Math.ceil(timeDiff / (1000 * 3600 * 24));

    return (timeDifferenceInDays);
}

/*
* handle checkbox event for room_check_count increment or decrement
*/
function checkbox_click(){
  $("input[type=checkbox]").on('click',function () {
    if ($('#booking_check_in').val() == "" || $('#booking_check_out').val() == "") {
      alert("Please select Arrival and Depature date")
      $(this).attr('checked', false);
    }else {
      if (this.checked) {
          room_checked_count = (room_checked_count + 1)
      }else{
          room_checked_count = (room_checked_count - 1)
      }
      price()
    }
  });
}

/*
* calculate total amount of rooms
*/
function price(){
  result = (room_price * days_between($('#booking_check_in').val(),$('#booking_check_out').val()))
  if (room_checked_count != 0) {
    result = (result * room_checked_count)
    $('#amount').text(result);
    $('#amount_hidden').val(result)
  }else {
     $('#amount').text(0);
  }
}

/*
* initialize all method
*/
function initialize() {
  var today = new Date().toISOString().substring(0, 10)

  //initialize datepicker
  booking_date()
  $('#bookings').dataTable()

  //ajax call at page load
  if ($('#room_name').text() != "") {
      room_available_ajax_call(today,today,$('#room_name').text())
  }

  $('.closed').on('click',function(){
      var effect = $(this).data('effect');
      $(this).closest('.panel')[effect]();
  })

  //update page for skipped booked room
  $.each($("input[name='booking[room_ids][]']:checked"), function(){
      room_selected.push($(this).val());
  });

  check_out_date = $('#booking_check_out').val()
}