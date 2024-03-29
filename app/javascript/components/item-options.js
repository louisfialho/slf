const displayItemOptions = () => {
  const optionsBtn = document.getElementById('options-btn');
  const options = document.getElementById('options');
  const moveTo = document.getElementById("move-to");
  // const list = document.getElementById("move-to-list");
  const addSpaceBox = document.getElementById('add-space');
  const listenBtn = document.getElementById('listen');

  optionsBtn.addEventListener("click", (event) => {
    // if (list.style.display === "none") {
      if (options.style.display === "none") {
        options.style.display = "";
      } else {
        options.style.display = "none";
      }
    // } else {
    //   list.style.display = "none";
    // }
  });

  document.addEventListener('click', function(event) {
    // if (list.style.display === "none") {
      var isClickInsideOpt = options.contains(event.target) ||  optionsBtn.contains(event.target);
      if (!isClickInsideOpt) {
        options.style.display = "none";
      }
    // }
  });

  if (moveTo) {
    moveTo.addEventListener('click', (event) => {
      options.style.display = "none";
      // list.style.display = "";
      var refresh = window.location + `/selected=$shelf`;
      history.replaceState({id: null}, 'Default State', refresh);
    });
  }


  // document.addEventListener('click', function(event) {
  //   // if (list.style.display === "") {
  //     // var isClickInsideList = optionsBtn.contains(event.target) || moveTo.contains(event.target);
  //     // if (!isClickInsideList) {
  //     //   list.style.display = "none";
  //     // }
  //   // }
  // });

  document.addEventListener('click', function(event) {
    if (addSpaceBox.style.display === "") {
      var isClickInsideSpaceBox = addSpaceBox.contains(event.target) // ||  list.contains(event.target);
      if (!isClickInsideSpaceBox) {
        addSpaceBox.style.display = "none";
      }
    }
  });

}

export { displayItemOptions };
