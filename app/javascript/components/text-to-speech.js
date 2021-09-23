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

  var listenBtn = document.getElementById("listen");

  let text = document.getElementById("txt-area").value;

  let itemId = document.getElementById("item-title").dataset.id;

  let player = document.getElementById('audioPlayback');

  let audioSource = document.getElementById('audioSource');

  // const shortText = async() => {
  //   const speechParamsSync = {
  //     OutputFormat: "mp3",
  //     Text: text,
  //     Engine: "standard", // to be changed to neural upon public release
  //     VoiceId: "Matthew"
  //   };
  //   try {
  //     let url = await getSynthesizeSpeechUrl({
  //       client, params: speechParamsSync
  //     });
  //     let player = document.getElementById('audioPlayback')
  //     player.style.display = "";
  //     replaceSourceLoadPlay(url)
  //   } catch (err) {
  //     // mettre failure message dans la feedback window
  //   }
  // }

  function replaceSourceLoadPlay(mp3Url) {
    if (document.body.contains(audioSource) && document.body.contains(player)) {
      audioSource.src = mp3Url;
      player.load();
      player.play();
    }
  }

  async function run() {
    try {
        await myFunctionThatCatches();
    } catch (e) {
        console.error(e);
        replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/2aa802f2-69fd-4976-a68d-386323ab4a1a.mp3")
    }
}

  const longText = async() => {
    const speechParamsAsync = {
      OutputS3BucketName: "polly-async",
      OutputFormat: "mp3",
      Text: text,
      Engine: "neural",
      VoiceId: "Matthew",
    };
    try {
      let firstValue = await client.send(
        new StartSpeechSynthesisTaskCommand(speechParamsAsync)
      );
      player.style.display = "";
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/9a9dfabe-5db7-463f-a6b6-c195c01b6af1.mp3")
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
            replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/cd8217f1-b84a-4978-a366-e39d0b107a4f.mp3")
          } else if (progressSeconds == 20){
            replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/9a0026c3-e32d-44de-bff6-a9248d9326e8.mp3")
          } else if (progressSeconds == 30){
            replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/f184b000-fd9c-4809-b14a-5a445b081afb.mp3")
          } else if (progressSeconds%10 == 0) {
            replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/f184b000-fd9c-4809-b14a-5a445b081afb.mp3")
          }
        } else if (pollingResponse == "completed") {
          clearInterval(interval);
          console.log(secondValue);
          replaceSourceLoadPlay(outputUri)
          Rails.ajax({
            url: "/items/persist_mp3_url",
            type: 'POST',
            data: `mp3_url=${outputUri}&id=${itemId}`,
            success: function(data) {
              console.log(data);
            }
          });
        } else if (pollingResponse == "failed") {
          replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/2aa802f2-69fd-4976-a68d-386323ab4a1a.mp3")
        }
      }, 1000);
    } catch (e) {
      console.log(e)
      player.style.display = "";
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/2aa802f2-69fd-4976-a68d-386323ab4a1a.mp3")
    }
  };

  if (document.body.contains(listenBtn)) {
    listenBtn.addEventListener("click", function() {
      document.getElementById('options').style.display = "none";
      document.getElementById('listen-option').remove()
      if (text.length < 200000) {
        longText()
      } else {
        player.style.display = "";
        replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/2aa802f2-69fd-4976-a68d-386323ab4a1a.mp3")
      }
    });
  }
};

export { textToSpeech };
