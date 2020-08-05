import { Elm } from './src/Main.elm'
import Constants from './constants.js'

const constants = {
  publicUrl: process.env.HOST_URL
};


var existingSession = JSON.parse(localStorage.getItem(Constants.storageKeys.session))

var flags = {
  // TODO: split constants into multiple parts with defined shapes
  // so they can be decoded inside of elm
  //"constants": Constants,
  "session": existingSession,
  "constants": constants
}

var app = Elm.Main.init({
  node: document.querySelector('main'),
  flags: flags
})

app.ports.storeSession.subscribe(function (val) {
  if (val === null) {
    localStorage.removeItem(Constants.storageKeys.session)
  } else {
    localStorage.setItem(Constants.storageKeys.session, JSON.stringify(val))
  }
  // Report that the session was updated succesfully.
  setTimeout(function () { app.ports.updateSession.send(val) }, 0)
})

// Whenever localStorage changes in another tab, report it if necessary.
window.addEventListener("storage", function (event) {
  if (event.storageArea === localStorage) {
    if (event.key === Constants.storageKeys.session) {
      app.ports.updateSession.send(event.newValue)
    }
  }
}, false)

