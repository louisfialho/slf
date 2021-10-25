const saveAudioTimestamp = () => {

  let itemId = document.getElementById("item-title").dataset.id;
  let player = document.getElementById('audioPlayback');

  setInterval(function() {

    let audio_timestamp = player.currentTime
    let audio_duration = player.duration
    console.log(audio_timestamp)
    Rails.ajax({
      url: "/items/persist_audio_timestamp",
      type: 'POST',
      data: `audio_timestamp=${audio_timestamp}&id=${itemId}&audio_duration=${audio_duration}`,
      success: function(data) {
        console.log(data);
      }
    });

  }, 5000); // In every 5 seconds

}

export { saveAudioTimestamp };
