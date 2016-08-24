var room_selected = [];
var room_price = 0;
var room_checke_count = 0

/*Initialize functions*/
$(document).ready(function(){
  //initialize datepicker
  booking_date()

  //ajax call at page load
  if ($('#room_name').text() != "") {
    room_available_ajax_call($('#booking_check_in').val(),$('#booking_check_out').val(),$('#room_name').text())
  }

  $('.closed').on('click',function(){
    var effect = $(this).data('effect');
    $(this).closest('.panel')[effect]();
  })

  //Intialize datatable
  $('#bookings').dataTable()

  //update page for skipped booked room
  $.each($("input[name='booking[room_ids][]']:checked"), function(){
    room_selected.push($(this).val());
  });
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
           alert("Check out Date must be higher than check_in date")
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
      room_checke_count = room_selected.length
      checkbox_click();
      price();
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
  });
}

/*
* find date differenc for calculating bill
*/
function days_between(date1, date2) {
    date1 = new Date(date1+" 00:00:00");
    date2 = new Date(date2+" 24:00:00");

    var timeDiff = Math.abs(date2.getTime() - date1.getTime());
    var timeDifferenceInDays = Math.ceil(timeDiff / (1000 * 3600 * 24));

    return (timeDifferenceInDays);
}

function checkbox_click(){
  $("input[type=checkbox]").on('click',function () {
    if ($('#booking_check_in').val() == "" || $('#booking_check_out').val() == "") {
      alert("Please select Arrival and Depature date")
      $(this).attr('checked', false);
    }else {
      if (this.checked) {
          room_checke_count = (room_checke_count + 1)
      }else{
          room_checke_count = (room_checke_count - 1)
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
  if (room_checke_count != 0) {
    result = (result * room_checke_count)
    $('#amount').text(result);
    $('#amount_hidden').val(result)
  }else {
     $('#amount').text(0);
  }
}