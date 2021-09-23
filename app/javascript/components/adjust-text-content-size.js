const adjustTextContentSize = () => {
  const txtArea = document.getElementById("text-content");
  const itemTitle = document.querySelector(".item-title");
  const navBar = document.getElementById("navshow");

  txtArea.style.height = (window.innerHeight) - navBar.clientHeight - itemTitle.clientHeight - 212 + "px"; // define height so that it ends right beffore the bottom
}

export { adjustTextContentSize };
