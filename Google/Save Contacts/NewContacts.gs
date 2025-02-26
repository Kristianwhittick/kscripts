/*jshint esversion: 6, laxbreak:true */

const step       = 100;
let count        = 0;
let countNew     = 0;
let countCheck   = 0;
let countUpdated = 0;
let countBin     = 0;

const jobs_cv          = GmailApp.createLabel('Jobs/cv');
const jobs_check       = GmailApp.createLabel('Jobs/cv/Check');
const jobs_uncontact   = GmailApp.createLabel('Jobs/cv/Uncontact');

const agentGroup       = assertContactGroup('Agent');
const agentAIGroup     = assertContactGroup('Agent_AI');
const agentUSAGroup    = assertContactGroup('Agent_USA');
const agentIgnoreGroup = assertContactGroup('Agent_Ignore');

const removeURL        = new RegExp(/https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)/, "gi"); 
const phoneExp         = new RegExp(/(\+[0-9]{1,3}[ ,-]?)?(\(0\)[ ,-]?)?[0-9][- 0-9]{5,12}[0-9]{3}( Ext[ :]{0,3}[0-9]{1,4})?/,"gi"); 

const mobileExp        = new RegExp(/^\+44 ?(\(0\) ?)?[7]|^07/);

/*
    NXX NXX XXXX
    NXX.NXX.XXXX
    NXX-NXX-XXXX
    (NXX) NXX XXXX
    (NXX) NXX.XXXX
    (NXX).NXX.XXXX
    (NXX) NXX-XXXX
    (NXX)NXX-XXXX

    (\([2-9][0-9]{2}\)[ .-]?|[2-9][0-9]{2}[ .-])[2-9][0-9]{2}[ .-][0-9]{4}
*/
const USAregExp = new RegExp(/(\([2-9][0-9]{2}\)[ .-]?|[2-9][0-9]{2}[ .-])[2-9][0-9]{2}[ .-][0-9]{4}/, "gi");

function maint() {
  startClean();
}

function toInteger(val){
  return parseInt(val).toString()
}

function startClean() {

  count = 0;
  countNew = 0;
  countCheck = 0;
  countUpdated = 0;

  let threads;
  do {
    threads = GmailApp.search("label:" + jobs_cv.getName(), count, step);
    count += threads.length;
    processThreads(threads , 0);
  } while ( threads.length == step) ;

  Logger.log("Finished processed = %s , New Contacts = %s, Updtated Contacts %s ", toInteger(count), toInteger(countNew), toInteger(countUpdated));


  // Clean the Ignore folder.
  count = 0;
  countNew = 0;
  countUpdated = 0;
  countBin = 0;
  
  do {
    threads = GmailApp.search("label:" + jobs_uncontact.getName(), count, step);
    processThreads(threads , 1);
  } while ( threads.length == step) ;

  Logger.log("Finished Messages Deleted = %s , New Ignore Contacts = %s, Updtated Ignore Contacts %s ", toInteger(countBin), toInteger(countNew), toInteger(countUpdated));

}


function processThreads(threads, action) {

  for (let i in threads) {
    if (action == 0) {
      processThread( threads[i]);
    } else {
      processIgnore( threads[i]);
    }
  }
}


function processThread(thisThread) {

  let contact = ContactsApp.getContact(getFromEmailAddress(thisThread));

  if (contact) {
    if (isInIgnoreGroup(contact)) {
      return;
    }

    processExistingContact(thisThread, contact);
  } else {
    processNewContact(thisThread);
  }
}


function processIgnore( thisThread) {

  let contact = ContactsApp.getContact(getFromEmailAddress(thisThread));

  if (contact) {
    removeContactFromOtherGroups(contact);
  } else {
    contact = createContact(thisThread);
  }

  if (!isInIgnoreGroup(contact)) {
    countUpdated++;
    contact.addToGroup(agentIgnoreGroup);
  }

  moveToTrash(thisThread);
  countBin++;
}


function isInIgnoreGroup(contact) {
  let groups = contact.getContactGroups();

  for (let i in groups){
    if (groups[i].getName() == agentIgnoreGroup.getName() ) {
      return true;
    }
  }        
  
  return false;
}


function removeContactFromOtherGroups( contact) {

  let groups = contact.getContactGroups();

  for (let i in groups) {
    if (groups[i].getName() !== agentIgnoreGroup.getName() ) {
      contact.removeFromGroup(groups[i]);
    }
  }
}


function processNewContact(thisThread) {

  const contact = createContact(thisThread);

  if (contact) {
    addPhoneNumebersAndComplete(thisThread, contact);
  }
}


function processExistingContact(thisThread, contact) {
  addPhoneNumebersAndComplete(thisThread, contact);
}


function addPhoneNumebersAndComplete(thisThread, contact) {

  setFirstEmailAsWork(contact);

  const plainBody = getPlainEmailBody(thisThread);

  contact.addToGroup(agentGroup);
  contact.addToGroup(agentAIGroup);

  let phonenums = getPhoneNumbersFromMessage(plainBody, phoneExp);

  if (checkUSA(plainBody)) {
    contact.addToGroup(agentUSAGroup);
    let usaphonenums = getPhoneNumbersFromMessage(plainBody, USAregExp);

    if (usaphonenums.length > 0) {
      for (let i in usaphonenums) {
        if ( !usaphonenums[i].includes("+") && usaphonenums[i].replace(/\D/g,'').charAt(0) !== '0' ) {
          usaphonenums[i] = '+1 ' + usaphonenums[i];
        }
      }

      phonenums = phonenums.concat(usaphonenums);
    }
  }

  if (phonenums.length > 0) {
    countUpdated++;
    addPhoneNumbers(contact, phonenums);    
  } else {
    labelCheck(thisThread);
    countCheck++;

  }
}



function createContact(thisThread) {

  const fromEmailAddress = getFromEmailAddress(thisThread);

  const names = getFirstLastNameCompany(
    getFromField(thisThread),
    fromEmailAddress
  );

  if (!names.firstName) {
    labelCheck(thisThread);
    countCheck++;
    return null;
  }

  Logger.log(
    "Create contact  %s  %s  %s  %s",
    names.firstName,
    names.lastName,
    fromEmailAddress,
    names.company
  );
  const contact = ContactsApp.createContact(
    names.firstName,
    names.lastName,
    fromEmailAddress
  );
  countNew++;
  Utilities.sleep(200);
  contact.addCompany(names.company, "");
  return contact;
}


function addPhoneNumbers(contact, phonenums) {
  phonenums.forEach((pnum) => {
    if (pnum) {
      let stripped = pnum.replace(/\D/g,'');

      if (! stripped.includes('7771560888')) {

        if (numberNotFound(contact, stripped )) {
          contact.addPhone(
            mobileExp.exec(pnum) !== null
              ? ContactsApp.Field.MOBILE_PHONE
              : ContactsApp.Field.WORK_PHONE,
            pnum
          );
        }
      }
    }
  });
}


function numberNotFound(contact, phonenum) {

  let cpons = contact.getPhones();

  for (let pos in cpons) {
    let sp = cpons[pos].getPhoneNumber().replace(/\D/g,'');

    if (sp === phonenum) {
      return false;
    }
  }
  
  return true;
}


function getFirstLastNameCompany(emailString, emailAdress) {
  const parts =
    emailString.indexOf(" ") > -1
      ? emailString.split(" ").slice(0, -1)
      : emailAdress.split("@")[0].split(".");

  return {
    firstName: titleCase(parts[0]),
    lastName: parts.length > 1 ? titleCase(parts[1]) : "",
    company: titleCase(emailAdress.split("@")[1].split(".")[0]),
  };
}


function checkUSA(body) {
  const phonenums = getPhoneNumbersFromMessage(body, USAregExp);

  return (phonenums && phonenums.length > 0);
}


function getPhoneNumbersFromMessage(pbody, phoneRegExp) {
  const body = pbody.replaceAll(removeURL, " url ");

  let phonenums = [];
  let result;
  while ((result = phoneRegExp.exec(body)) !== null) {
    pn = result[0].replace(/\s+/g, "");
    phonenums.push(pn);
  }

  return [...new Set(phonenums)];
}
