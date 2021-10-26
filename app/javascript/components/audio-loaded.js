const loadAudio = () => {
  let player = document.getElementById('audioPlayback');
  if (userAgent.match(/safari/i)) {
    player.onloadeddata = function() {
      player.style.display = "";
    };
  }
}

export { loadAudio };
