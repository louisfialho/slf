const expandSuperspace = () => {
  let notStarted = document.getElementById("not-started");
  let inProgress = document.getElementById("in-progress");
  let finished = document.getElementById("finished");

  let notStartedId = notStarted.dataset.id
  let inProgressId = inProgress.dataset.id
  let finishedId = finished.dataset.id

  let expandNotStarted = document.getElementById("expand-not-started");
  let expandInProgress = document.getElementById("expand-in-progress");
  let expandFinished = document.getElementById("expand-finished");

  // 1

  notStarted.style.cursor = "pointer";

  notStarted.addEventListener("mouseenter", function( event ) {
    expandNotStarted.style.display = ""

  });

  notStarted.addEventListener("mouseleave", function( event ) {
    expandNotStarted.style.display = "none"
  });

  // object
  var x = document.querySelector('#not-started-grid');

  // Listen for click events on body
  notStarted.addEventListener('click', function (event) {
      if (x.contains(event.target)) { // if item contains
          console.log('clicked item'); // redirect item
      } else {
          window.location.href = `https://www.shelf.so/spaces/${notStartedId}`
      }
  });

  // 2

  inProgress.style.cursor = "pointer";

  inProgress.addEventListener("mouseenter", function( event ) {
    expandInProgress.style.display = ""

  });

  inProgress.addEventListener("mouseleave", function( event ) {
    expandInProgress.style.display = "none"
  });

  // object
  var y = document.querySelector('#in-progress-grid');

  // Listen for click events on body
  inProgress.addEventListener('click', function (event) {
      if (y.contains(event.target)) { // if item contains
          console.log('clicked item'); // redirect item
      } else {
          window.location.href = `http://localhost:3000/spaces/${inProgressId}`
      }
  });

  // 3

  finished.style.cursor = "pointer";

  finished.addEventListener("mouseenter", function( event ) {
    expandFinished.style.display = ""

  });

  finished.addEventListener("mouseleave", function( event ) {
    expandFinished.style.display = "none"
  });

  // object
  var z = document.querySelector('#finished-grid');

  // Listen for click events on body
  finished.addEventListener('click', function (event) {
      if (z.contains(event.target)) { // if item contains
          console.log('clicked item'); // redirect item
      } else {
          window.location.href = `http://localhost:3000/spaces/${finishedId}`
      }
  });
}

export { expandSuperspace };
