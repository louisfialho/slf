const textToSpeech = () => {

  const { CognitoIdentityClient } = require("@aws-sdk/client-cognito-identity");
  const {
    fromCognitoIdentityPool,
  } = require("@aws-sdk/credential-provider-cognito-identity");
  const { Polly, StartSpeechSynthesisTaskCommand, GetSpeechSynthesisTaskCommand } = require("@aws-sdk/client-polly");
  const { getSynthesizeSpeechUrl } = require("@aws-sdk/polly-request-presigner");

  // Create the Polly service client, assigning your credentials
  const client = new Polly({
    region: "eu-west-2",
    credentials: {
      accessKeyId: process.env.AWS_ACCESS_KEY_ID,
      secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
    }
  });

  var listenBtn = document.getElementById("listen")

  let text = document.getElementById("txt-area").value;

  let itemId = document.getElementById("item-title").dataset.id

  let player = document.getElementById('audioPlayback')

  const shortText = async() => {
    const speechParamsSync = {
      OutputFormat: "mp3",
      Text: text,
      VoiceId: "Matthew"
    };
    try {
      let url = await getSynthesizeSpeechUrl({
        client, params: speechParamsSync
      });
      let player = document.getElementById('audioPlayback')
      player.style.display = "";
      document.getElementById('audioSource').src = url;
      player.load();
      player.play()
    } catch (err) {
      // mettre failure message dans la feedback window
    }
  }

  const longText = async() => {
    const speechParamsAsync = {
      OutputS3BucketName: "polly-async",
      OutputFormat: "mp3",
      Text: text,
      VoiceId: "Matthew",
    };
    let firstValue = await client.send(
      new StartSpeechSynthesisTaskCommand(speechParamsAsync)
    );
    console.log(firstValue);
    let taskId = firstValue.SynthesisTask.TaskId;
    console.log(taskId)
    let outputUri = firstValue.SynthesisTask.OutputUri;
    console.log(outputUri)
    // mettre waiting message dans la feed window
    // polling takes quite some time. Improvement: test SNS
    const interval = setInterval(async () => {
      let secondValue = await client.send(
        new GetSpeechSynthesisTaskCommand({TaskId: taskId})
      )
      let pollingResponse = secondValue.SynthesisTask.TaskStatus
      console.log(pollingResponse)
      if ((pollingResponse == "scheduled") || (pollingResponse == "inProgress")) {
        // rien
      } else if (pollingResponse == "completed") {
        clearInterval(interval);
        console.log(secondValue);
        // load le player
        document.getElementById('audioSource').src = outputUri;
        player.load();
        player.play();
        Rails.ajax({
          url: "/items/persist_mp3_url",
          type: 'POST',
          data: `mp3_url=${outputUri}&id=${itemId}`,
          success: function(data) {
            console.log(data);
          }
        });
      } else if (pollingResponse == "failed") {
        // mettre failure message dans la feedback window
      }
    }, 1000);
  };

  if (document.body.contains(listenBtn)) {
    listenBtn.addEventListener("click", function() {
      document.getElementById('options').style.display = "none";
      document.getElementById('listen-option').remove()
      player.style.display = "";
      if (text.length < 3000) {
        shortText()
      } else if (text.length < 200000) {
        longText()
      }
      // else text too long
    });
  }
};

export { textToSpeech };
