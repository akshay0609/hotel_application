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
       room_available_ajax_call($('#booking_check_in').val(),date,$('#room_name').text());
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
  //split the values to arrays date1[0] is the year, [1] the month and [2] the day
  date1 = date1.split('-');
  date2 = date2.split('-');

  //convert the array to a Date object
  date1 = new Date(date1[0], date1[1], date1[2]);
  date2 = new Date(date2[0], date2[1], date2[2]);

  //getTime() method and get the unixtime
  date1_unixtime = parseInt(date1.getTime() / 1000);
  date2_unixtime = parseInt(date2.getTime() / 1000);

  //calculated difference in seconds
  var timeDifference = date2_unixtime - date1_unixtime;

  var timeDifferenceInHours = timeDifference / 60 / 60;

  var timeDifferenceInDays = timeDifferenceInHours  / 24;

  if (timeDifferenceInDays == 0) {
      return 1
  }
  return (timeDifferenceInDays + 1);
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