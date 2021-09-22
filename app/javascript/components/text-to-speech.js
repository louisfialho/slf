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
      Engine: "standard", // to be changed to neural upon public release
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

  async function run() {
    try {
        await myFunctionThatCatches();
    } catch (e) {
        console.error(e);
        document.getElementById('audioSource').src = "https://polly-async.s3.eu-west-2.amazonaws.com/2aa802f2-69fd-4976-a68d-386323ab4a1a.mp3";
        player.load();
        player.play();
    }
}

  const longText = async() => {
    const speechParamsAsync = {
      OutputS3BucketName: "polly-async",
      OutputFormat: "mp3",
      Text: text,
      Engine: "standard", // to be changed to neural upon public release
      VoiceId: "Matthew",
    };
    try {
      let firstValue = await client.send(
        new StartSpeechSynthesisTaskCommand(speechParamsAsync)
      );
    document.getElementById('audioSource').src = "https://polly-async.s3.eu-west-2.amazonaws.com/9a9dfabe-5db7-463f-a6b6-c195c01b6af1.mp3";
    player.style.display = "";
    player.play();
    console.log(firstValue);
    let taskId = firstValue.SynthesisTask.TaskId;
    console.log(taskId)
    let outputUri = firstValue.SynthesisTask.OutputUri;
    console.log(outputUri)
    let progressSeconds = 0
    const interval = setInterval(async () => {
      let secondValue = await client.send(
        new GetSpeechSynthesisTaskCommand({TaskId: taskId})
      )
      let pollingResponse = secondValue.SynthesisTask.TaskStatus
      console.log(pollingResponse)
      if (pollingResponse == "inProgress") {
        console.log(progressSeconds)
        progressSeconds++;
        if (progressSeconds == 10) {
          document.getElementById('audioSource').src = "https://polly-async.s3.eu-west-2.amazonaws.com/cd8217f1-b84a-4978-a366-e39d0b107a4f.mp3";
          player.load();
          player.play();
        } else if (progressSeconds == 20){
          document.getElementById('audioSource').src = "https://polly-async.s3.eu-west-2.amazonaws.com/9a0026c3-e32d-44de-bff6-a9248d9326e8.mp3";
          player.load();
          player.play();
        } else if (progressSeconds == 30){
          document.getElementById('audioSource').src = "https://polly-async.s3.eu-west-2.amazonaws.com/f184b000-fd9c-4809-b14a-5a445b081afb.mp3";
          player.load();
          player.play();
        }
      } else if (pollingResponse == "completed") {
        clearInterval(interval);
        console.log(secondValue);
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
        document.getElementById('audioSource').src = "https://polly-async.s3.eu-west-2.amazonaws.com/2aa802f2-69fd-4976-a68d-386323ab4a1a.mp3";
        player.load();
        player.play();
      }
    }, 1000);
    } catch (e) {
      console.log(e)
      player.style.display = "";
      document.getElementById('audioSource').src = "https://polly-async.s3.eu-west-2.amazonaws.com/2aa802f2-69fd-4976-a68d-386323ab4a1a.mp3";
      player.load();
      player.play();
    }
  };

  if (document.body.contains(listenBtn)) {
    listenBtn.addEventListener("click", function() {
      document.getElementById('options').style.display = "none";
      document.getElementById('listen-option').remove()
      if (text.length < 3000) {
        shortText()
      } else if (text.length < 200000) {
        longText()
      } else {
        player.style.display = "";
        document.getElementById('audioSource').src = "https://polly-async.s3.eu-west-2.amazonaws.com/2aa802f2-69fd-4976-a68d-386323ab4a1a.mp3";
        player.load();
        player.play();
      }
    });
  }
};

export { textToSpeech };
