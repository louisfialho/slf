const displaySave = () => {
  const saveNotes = document.getElementById("save-notes");
  const txtArea = document.getElementById("txt-area");
  const itemTitle = document.querySelector(".item-title");
  const navBar = document.getElementById("navshow");

  txtArea.style.height = (window.innerHeight) - navBar.clientHeight - itemTitle.clientHeight - 200 + "px"; // define height so that it ends right beffore the bottom

  txtArea.addEventListener('focus', (event) => {
    saveNotes.style.display = "";
  });
}

export { displaySave };
