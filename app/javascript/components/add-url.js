const displayAddUrl = () => {
  const addUrlBox = document.getElementById('add-url');
  const addOptionsBox = document.getElementById('add-options');
  const newObjectBtn = document.getElementById('new-object');

  newObjectBtn.addEventListener("click", (event) => {
    addOptionsBox.style.display = "none";
    addUrlBox.style.display = "";
    document.getElementById('item_url').focus()
  });
}

export { displayAddUrl };
