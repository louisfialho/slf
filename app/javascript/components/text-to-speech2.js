const textToSpeech2 = () => {

  // init
  const { PollyClient, SynthesizeSpeechCommand } = require("@aws-sdk/client-polly");
  const client = new PollyClient({
    region: "eu-west-2",
    credentials: {
      accessKeyId: process.env.AWS_ACCESS_KEY_ID,
      secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
    }
  });
  const fs = require('fs')


  // vars

  let listenBtn = document.getElementById("listen");

  let text = document.getElementById("text-content").innerText;
  text = text.replace(/(\r\n|\n|\r)/gm, ". ");
  text = text.replace(/([\u2700-\u27BF]|[\uE000-\uF8FF]|\uD83C[\uDC00-\uDFFF]|\uD83D[\uDC00-\uDFFF]|[\u2011-\u26FF]|\uD83E[\uDD10-\uDDFF])/g, " ");
  text = text.replace(/( —)/gm, ",");
  let textLength = text.length;

  let player = document.getElementById('audioPlayback');
  let audioSource = document.getElementById('audioSource');

  // request

  const input = {
    OutputFormat: "mp3",
    Text: text,
    Engine: "neural",
    VoiceId: "Matthew",
  };

  const command = new SynthesizeSpeechCommand(input);


  // async/await.
  async function f1() {
    try {
      const response = await client.send(command);
      var uInt8Array = new Uint8Array(response.AudioStream);
      var arrayBuffer = uInt8Array.buffer;
      var blob = new Blob([arrayBuffer]);
      const file = new File([blob], "test");
      audioSource.src = url;
      player.style.display = "";
      player.load();
      player.play();
    } catch (error) {
      console.log(error)
    } finally {
      // finally.
    }
  }

  // throwing
  if (document.body.contains(listenBtn)) {
    listenBtn.addEventListener("click", function() {
      document.getElementById('options').style.display = "none";
      document.getElementById('listen-option').remove()
      f1();
    });
  }
};

export { textToSpeech2 };
