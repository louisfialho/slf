function checkCookie(url, name){
    return new Promise((resolve, reject) => {
        chrome.cookies.get({
          url: url,
          name: name
        },
        function (cookie) {
          resolve(cookie)
        })
    })
}



