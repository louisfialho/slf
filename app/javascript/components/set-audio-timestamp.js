const setAudioTimestamp = () => {

  let audio_timestamp = document.getElementById("item-title").dataset.timestamp;
  let player = document.getElementById('audioPlayback');

  let userAgent = navigator.userAgent;

  if (userAgent.match(/safari/i)) {
    if ((audio_timestamp!='0') && (audio_timestamp!='')) {

      player.onloadeddata = function() {
          player.currentTime = audio_timestamp;
      };
    }
  } else {
    if ((audio_timestamp!='0') && (audio_timestamp!='')) {
      player.currentTime = audio_timestamp;
    }
  }
}

export { setAudioTimestamp };
