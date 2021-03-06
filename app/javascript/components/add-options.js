const displayAddOptions = () => {
  const addBtn = document.getElementById('add-btn');
  const addOptionsBox = document.getElementById('add-options');
  const actions = document.getElementById('add-action');
  const newObjectBtn = document.getElementById('new-object');
  const newSpaceBtn = document.getElementById('new-space');
  const addUrlBox = document.getElementById('add-url');
  const addSpaceBox = document.getElementById('add-space');

  addBtn.addEventListener("mouseover", (event) => {
    addBtn.className = "grey-circle options";
    setTimeout(function(){ actions.style.display = ""; }, 250);
  });

  addBtn.addEventListener("mouseout", (event) => {
    addBtn.className = "options";
    actions.style.display = "none"
  });

 addBtn.addEventListener("click", (event) => {
  if (addUrlBox.style.display === "none" && addSpaceBox.style.display === "none") {
    if (addOptionsBox.style.display === "none") {
      actions.style.display = "none"
      addOptionsBox.style.display = "";
    } else {
      addOptionsBox.style.display = "none";
    }
  } else if (addUrlBox.style.display === "" && addSpaceBox.style.display === "none") {
    addUrlBox.style.display = "none"
  } else if (addUrlBox.style.display === "none" && addSpaceBox.style.display === "") {
    addSpaceBox.style.display = "none"
  }
  });

  document.addEventListener('click', function(event) {
    if (addUrlBox.style.display === "none") {
      var isClickInsideOpt = addOptionsBox.contains(event.target) ||  addBtn.contains(event.target);
      if (!isClickInsideOpt) {
        addOptionsBox.style.display = "none";
      }
    }
  });

  newObjectBtn.addEventListener("click", (event) => {
    addOptionsBox.style.display = "none";
    addUrlBox.style.display = "";
    const itemForm = document.getElementById('new_item')
    const itemTxtInpt = document.getElementById('item_url')
    const loading = document.getElementById('loading')
    const itemPrompt = document.getElementById('add-url-prompt')
    itemTxtInpt.focus();
    itemTxtInpt.addEventListener('paste', function(event) {
      itemPrompt.innerHTML = "Adding this new object 📚 to your shelf..."
      setTimeout(function(){ Rails.fire(itemForm, 'submit'); }, 0.1);
    });
  });

  document.addEventListener('click', function(event) {
    if (addUrlBox.style.display === "") {
      var isClickInsideUrlBox = addUrlBox.contains(event.target) ||  addBtn.contains(event.target) || newObjectBtn.contains(event.target);
      if (!isClickInsideUrlBox) {
        addUrlBox.style.display = "none";
      }
    }
  });

  newSpaceBtn.addEventListener("click", (event) => {
    addOptionsBox.style.display = "none";
    addSpaceBox.style.display = "";
    const spaceForm = document.getElementById('new_space')
    const spaceTxtInpt = document.getElementById('space_name')
    spaceTxtInpt.focus();
    spaceTxtInpt.addEventListener('paste', function(event) {
      setTimeout(function(){ spaceForm.submit() }, 0.1);
    });
  });

  document.addEventListener('click', function(event) {
    if (addSpaceBox.style.display === "") {
      var isClickInsideSpaceBox = addSpaceBox.contains(event.target) ||  addBtn.contains(event.target) || newSpaceBtn.contains(event.target);
      if (!isClickInsideSpaceBox) {
        addSpaceBox.style.display = "none";
      }
    }
  });

  // filters

  // status

  const statusFilterBtn = document.getElementById('status-filter-btn');
  const statusOptionsCtn = document.getElementById('status-options-ctn');

  statusFilterBtn.addEventListener("click", (event) => {
    if (statusOptionsCtn.style.display === "none") {
      statusOptionsCtn.style.display = ""
    } else if (statusOptionsCtn.style.display === "") {
      statusOptionsCtn.style.display = "none"
    }
  });

  document.addEventListener('click', function(event) {
    if (statusOptionsCtn.style.display === "") {
      var isClickInsideOptionsCtn = statusOptionsCtn.contains(event.target) ||  statusFilterBtn.contains(event.target);
      if (!isClickInsideOptionsCtn) {
        statusOptionsCtn.style.display = "none";
      }
    }
  });

  const notStarted = document.getElementById('not-started');
  const started = document.getElementById('started');
  const finished = document.getElementById('finished');
  const objects = document.querySelectorAll(".object");
  const filterBtns = document.querySelectorAll(".filter-btn");


  notStarted.addEventListener("click", (event) => {
    if (!notStarted.classList.contains("active-btn")) {
      for (var i=0;i<objects.length;i+=1) {
        objects[i].style.display = "";
      }
      for (var i=0;i<filterBtns.length;i+=1) {
        if (filterBtns[i].classList.contains("active-btn")) {
          filterBtns[i].classList.remove("active-btn");
        }
      }
      var elems = document.querySelectorAll('div[data-status]:not([data-status="1"])');
      for (var i=0;i<elems.length;i+=1){
        elems[i].style.display = "none";
      }
      statusOptionsCtn.style.display = "none";
      statusFilterBtn.classList.add("active-btn");
      statusFilterBtn.innerHTML = "Status (1)";
      notStarted.classList.add("active-btn");
    } else if (notStarted.classList.contains("active-btn")) {
      var elems = document.querySelectorAll('div[data-status]:not([data-status="1"])');
      for (var i=0;i<elems.length;i+=1){
        elems[i].style.display = "";
      }
      statusOptionsCtn.style.display = "none";
      statusFilterBtn.classList.remove("active-btn");
      statusFilterBtn.innerHTML = "Status";
      notStarted.classList.remove("active-btn");
    }
  });

  started.addEventListener("click", (event) => {
    if (!started.classList.contains("active-btn")) {
      for (var i=0;i<objects.length;i+=1){
        objects[i].style.display = "";
      }
      for (var i=0;i<filterBtns.length;i+=1) {
        if (filterBtns[i].classList.contains("active-btn")) {
          filterBtns[i].classList.remove("active-btn");
        }
      }
      var elems = document.querySelectorAll('div[data-status]:not([data-status="2"])');
      for (var i=0;i<elems.length;i+=1){
        elems[i].style.display = "none";
      }
      statusOptionsCtn.style.display = "none";
      statusFilterBtn.classList.add("active-btn");
      statusFilterBtn.innerHTML = "Status (1)";
      started.classList.add("active-btn");
    } else if (started.classList.contains("active-btn")) {
      var elems = document.querySelectorAll('div[data-status]:not([data-status="2"])');
      for (var i=0;i<elems.length;i+=1){
        elems[i].style.display = "";
      }
      statusOptionsCtn.style.display = "none";
      statusFilterBtn.classList.remove("active-btn");
      statusFilterBtn.innerHTML = "Status";
      started.classList.remove("active-btn");
    }
  });

  finished.addEventListener("click", (event) => {
    if (!finished.classList.contains("active-btn")) {
      for (var i=0;i<objects.length;i+=1) {
        objects[i].style.display = "";
      }
      for (var i=0;i<filterBtns.length;i+=1) {
        if (filterBtns[i].classList.contains("active-btn")) {
          filterBtns[i].classList.remove("active-btn");
        }
      }
      var elems = document.querySelectorAll('div[data-status]:not([data-status="3"])');
      for (var i=0;i<elems.length;i+=1) {
        elems[i].style.display = "none";
      }
      statusOptionsCtn.style.display = "none";
      statusFilterBtn.classList.add("active-btn");
      statusFilterBtn.innerHTML = "Status (1)";
      finished.classList.add("active-btn");
    } else if (finished.classList.contains("active-btn")) {
      var elems = document.querySelectorAll('div[data-status]:not([data-status="3"])');
      for (var i=0;i<elems.length;i+=1){
        elems[i].style.display = "";
      }
      statusOptionsCtn.style.display = "none";
      statusFilterBtn.classList.remove("active-btn");
      statusFilterBtn.innerHTML = "Status";
      finished.classList.remove("active-btn");
    }
  });

  // The above code is not DRY: needs refactoring.

}

export { displayAddOptions };



