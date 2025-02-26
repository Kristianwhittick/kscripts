function assertContactGroup(name) {
  let cg = ContactsApp.getContactGroup(name);
  return cg ? cg : ContactsApp.createContactGroup(name);
}

function getFirstMessage(thisThread) {
  return thisThread.getMessages()[0];
}

function getFromField(thisThread) {
  return getFirstMessage(thisThread).getFrom();
}

function getFromEmailAddress(thisThread) {
  return getFromField(thisThread).replace(/^.*<(.+)>$/, '$1');
}

function getPlainEmailBody(thisThread) {
  return getFirstMessage(thisThread).getPlainBody();
}

function setFirstEmailAsWork(contact) {
  contact.getEmails()[0].setLabel(ContactsApp.Field.WORK_EMAIL);
}

function titleCase(name) {
  return !name || name.length == 0
    ? name
    : name.charAt(0).toUpperCase() + name.slice(1).toLowerCase();
}

function labelCheck(thisThread) {
  thisThread.addLabel(jobs_check);
}

function moveToTrash(thisThread) {
  thisThread.moveToTrash();
}
