function countEmailsBySender() {
  var senderCount = {};
  var threads;
  var pageSize = 100; // Number of threads to process per batch
  var start = 0;

  // Loop to get threads in batches until there are no more threads
  do {
    threads = GmailApp.getInboxThreads(start, pageSize);
    for (var i = 0; i < threads.length; i++) {
      var sender = threads[i].getMessages()[0].getFrom();
      if (senderCount[sender]) {
        senderCount[sender]++;
      } else {
        senderCount[sender] = 1;
      }
    }
    start += pageSize; // Move to the next batch
  } while (threads.length === pageSize);

  // Convert the senderCount object to an array and sort by count in descending order
  var sortedSenders = Object.entries(senderCount).sort(function(a, b) {
    return b[1] - a[1];
  });

  var singles = 0
  var outstr = ""
  // Log the sorted list of top senders
  for (var j = 0; j < sortedSenders.length; j++) {
    if ( sortedSenders[j][1] == 1 ) {
      singles = sortedSenders.length - j;
      break;
    }
    outstr += sortedSenders[j][0] + ": " + sortedSenders[j][1] + "\n";
  }

  outstr += "Reset = " + singles + "\n";

  Logger.log(outstr);
}
