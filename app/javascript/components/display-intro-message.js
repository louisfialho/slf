const displayIntroMessage = () => {
  const userIdCtn = document.getElementById("user-id-ctn");
  const introMessage = document.getElementById("intro-message");

  userIdCtn.addEventListener("click", (event) => {
    if (introMessage.style.display === "none") {
      introMessage.style.display = "";
    } else {
      introMessage.style.display = "none";
    }
  });

  document.addEventListener('click', function(event) {
    var isClickInsideUserIdCtnOrIntroMsg = userIdCtn.contains(event.target) ||  introMessage.contains(event.target);
    if (!isClickInsideUserIdCtnOrIntroMsg) {
      if (introMessage.style.display === "") {
        introMessage.style.display = "none"
      }
    }
  });
}

export { displayIntroMessage };
