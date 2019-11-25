import { Elm } from './src/Main.elm'
import Constants from './constants.js'

Elm.Main.init({
  node: document.querySelector('main')
})

var flags = {
  "constants": Constants,
  "session": localStorage.getItem(Constants.storageKeys.session)
}

var app = Elm.Main.init({ flags: flags })
console.log(app);

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
