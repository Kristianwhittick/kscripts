
// for API reference go to https://developers.google.com/apps-script/reference/calendar/calendar-app

function update_bin_events() {

  // Change the date range where you want this scrip to be executed
  var fromDate = new Date("2021-01-1");
  var toDate = new Date("2022-04-05");
  Logger.log("Events to be deleted starting: " + fromDate);
  Logger.log("Events to be deleted starting: " + toDate);

  // put your email address here, follow the prompts to give permissions to this script to access your calendar
  var calendarName = 'kristianwhittick@googlemail.com';

  var calendar = CalendarApp.getCalendarsByName(calendarName)[0];

  // get events from date, to date and with a search term "YOUR SEARCH TERM"
  var events = calendar.getEvents(fromDate, toDate,{search:"RECYCLING"});
  changeReminders(events);
  
  events = calendar.getEvents(fromDate, toDate,{search:"REFUSE"});
  changeReminders(events);
}

function changeReminders(events) {

  for (var i = 0; i < events.length; i++) {
    var single_cal_event = events[i];

    Logger.log('Item ' + single_cal_event.getTitle() + ' that occurs on ' + single_cal_event.getStartTime()); 

    single_cal_event.removeAllReminders();
    single_cal_event.addPopupReminder(720);
  }

}