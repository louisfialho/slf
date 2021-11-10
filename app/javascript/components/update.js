const updateStatus = () => {
  const upStat = document.getElementById('update-status');
  const upRank = document.getElementById('update-rank');
  const optStat = document.getElementById('opts-status');
  const optRank = document.getElementById('opts-rank');

  upStat.addEventListener("click", (event) => {
    if (optStat.style.display === "none") {
      optStat.style.display = "";
    } else {
      optStat.style.display = "none";
    }
  });

  upRank.addEventListener("click", (event) => {
    if (optRank.style.display === "none") {
      optRank.style.display = "";
    } else {
      optRank.style.display = "none";
    }
  });

document.addEventListener('click', function(event) {
  var isClickInsideStat = optStat.contains(event.target) ||  upStat.contains(event.target);

  if (!isClickInsideStat) {
    if (optStat.style.display === "") {
      optStat.style.display = "none";
    }
  }
});

document.addEventListener('click', function(event) {
  var isClickInsideRank = optRank.contains(event.target) ||  upRank.contains(event.target);

  if (!isClickInsideRank) {
    if (optRank.style.display === "") {
      optRank.style.display = "none";
    }
  }
});

}

export { updateStatus };
