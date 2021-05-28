function send(chrome_auth_token, current_url) {
  const btn = document.querySelector("#send-data");
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
    btn.setAttribute("target", "_blank");
    btn.setAttribute("rel", "noopener noreferrer");
    btn.setAttribute("href", data.url);
    btn.innerHTML = "open in shelf!";
  });
}

var bgPage = chrome.extension.getBackgroundPage();
bgPage.checkCookie('http://localhost:3000/', 'chrome_auth_token')
.then(cookie => {
  if (cookie == null) {
    const signInBtn = document.getElementById('sign-in');
    signInBtn.style.display = ""
  } else {
    chrome.tabs.query({active: true, lastFocusedWindow: true}, tabs => {
      const addBtn = document.getElementById('send-data');
      addBtn.style.display = ""
      addBtn.addEventListener("click", function(){send(cookie.value, tabs[0].url)});
    });
  }
});



