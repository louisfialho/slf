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

  let textLength = text.length;

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

  function playIntroAudio() {
    if (textLength < 1000) {
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/a3f999a0-cacd-4b83-896e-154ee02b1a66.mp3") // announcing about 10 secs
    } else if (textLength < 4500) {
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/f7139878-b1bf-4dd9-83db-92ddfdc5e4c9.mp3") // announcing about 20 secs
    } else if (textLength < 9000) {
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/3ce22452-d73b-45ab-a802-003b974b11a2.mp3") // announcing about 30 secs
    } else if (textLength < 13500) {
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/f0adfeed-1b7c-45af-9b31-ff6f0fd659e9.mp3") // announcing about 40 secs
    } else if (textLength < 18000) {
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/51ba9d62-0f45-43cf-8aca-45e302832ae1.mp3") // announcing about 50 secs
    } else if (textLength < 22500){
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/7a768db5-e04f-41e2-b51b-eb0518df8ebc.mp3") // announcing about one minute
    } else if (textLength < 27000){
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/8141fc7b-fd3c-43ad-b908-5f1d3ff2f3c1.mp3") // announcing about one minute and ten seconds
    } else if (textLength < 31500){
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/f44b379e-3139-431a-8dc4-594122240be3.mp3") // announcing about one minute and twenty seconds
    } else if (textLength < 36000) {
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/9308f52c-69ae-442c-9e32-3c379927b23b.mp3") // announcing about one minute and a half
    } else if (textLength < 49500) {
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/3a3b537f-afbf-4648-a74a-56cd749cd2b1.mp3") // announcing about 2 minutes
    } else if (textLength < 75000){
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/e7cedfa3-e13d-44b1-b73b-1296f72802a3.mp3") // announcing about 3 minutes
    } else if (textLength < 100000){
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/ae716528-e10c-424e-9a81-fb77ec521bb2.mp3") // announcing about 4 minutes
    } else {
      replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/93132d9b-f936-4c61-9330-fcc0ef4493c9.mp3") // announcing more than 4 minutes
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
      playIntroAudio()
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
      if (textLength < 200000) {
        longText()
      } else {
        player.style.display = "";
        replaceSourceLoadPlay("https://polly-async.s3.eu-west-2.amazonaws.com/2aa802f2-69fd-4976-a68d-386323ab4a1a.mp3")
      }
    });
  }
};

export { textToSpeech };
