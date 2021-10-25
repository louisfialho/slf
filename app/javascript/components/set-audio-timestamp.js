const setAudioTimestamp = () => {

  let audio_timestamp = document.getElementById("item-title").dataset.timestamp;

  if ((audio_timestamp!='0') && (audio_timestamp!='')) {
    let player = document.getElementById('audioPlayback');
    player.currentTime = audio_timestamp;
  }

}

export { setAudioTimestamp };
