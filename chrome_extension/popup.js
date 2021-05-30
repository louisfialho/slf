function send(chrome_auth_token, current_url) {
  const btn = document.querySelector("#send-data");
  btn.innerHTML = "Please wait 🤖";
  fetch('http://localhost:3000/api/v1/items', { // https://shelf.so/api/v1/items
    method: 'POST',
    headers: {
      "Content-Type": "application/json",
      "Chrome-Auth-Token": chrome_auth_token
    },
    body: JSON.stringify({"url": current_url})
  })
  .then(response => response.json())
  .then((data) => {
    if (data.url) {
      btn.setAttribute("target", "_blank");
      btn.setAttribute("rel", "noopener noreferrer");
      btn.setAttribute("href", data.url);
      btn.innerHTML = "Open 👉";
      document.addEventListener('keydown', function(event) {
        if (event.metaKey && event.keyCode == 75) {
          // call your function to do the thing
          var newURL = data.url;
          chrome.tabs.create({ url: newURL });
        }
      });
    } else if (data.error) {
      btn.innerHTML = "URL not found 🤖";
    }
  });
}

function displayInstructions(btnToRemove) {
  const shortcuts = document.getElementById('shortcuts');
  var isMac = navigator.platform.toUpperCase().indexOf('MAC')>=0;
  const shortcutInstructionsMac = document.getElementById('shortcut-instructions-mac');
  const shortcutInstructionsPc = document.getElementById('shortcut-instructions-pc');
  const back = document.getElementById('back');
  shortcuts.addEventListener("click", (event) => {
    btnToRemove.style.display = "none"
    if (isMac) {
      shortcutInstructionsMac.style.display = ""
    } else {
      shortcutInstructionsPc.style.display = ""
    }
    shortcuts.style.display = "none"
    back.style.display = ""
    if (back.style.display == "") {
    back.addEventListener("click", (event) => {
      back.style.display = "none"
      if (shortcutInstructionsMac.style.display == "") {
        shortcutInstructionsMac.style.display = "none"
      } else if (shortcutInstructionsPc.style.display == "") {
        shortcutInstructionsPc.style.display = "none"
      }
      btnToRemove.style.display = ""
      shortcuts.style.display = ""
    });
  }
  });
}

var bgPage = chrome.extension.getBackgroundPage();
bgPage.checkCookie('http://localhost:3000/', 'chrome_auth_token')
.then(cookie => {
  if (cookie == null) {
    const signInBtn = document.getElementById('sign-in');
    const contact = document.getElementById('contact');
    signInBtn.style.display = ""
    contact.style.display = ""
  } else {
    const addBtn = document.getElementById('send-data');
    const shortcuts = document.getElementById('shortcuts');
    addBtn.style.display = ""
    shortcuts.style.display = ""
    displayInstructions(addBtn)
    chrome.tabs.query({active: true, lastFocusedWindow: true}, tabs => {
      document.addEventListener('keydown', function(event) {
        if (event.metaKey && event.keyCode == 74) {
            // call your function to do the thing
          send(cookie.value, tabs[0].url)
        }
      });
      addBtn.addEventListener('click', function(){send(cookie.value, tabs[0].url)});
    });
  }
});


