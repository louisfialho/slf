const synthesizeText = () => {

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

  var synthesizeBtn = document.querySelector("#synthesize")

  let text = document.getElementById("txt-area").value;

  let itemId = document.getElementById("item-title").dataset.id

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
      document.getElementById('audioSource').src = url;
      document.getElementById('audioPlayback').load();
    } catch (err) {
      synthesizeBtn.innerHTML = err;
    }
  }

  const longText = async() => {
    const speechParamsAsync = {
      OutputS3BucketName: "polly-async",
      OutputFormat: "mp3",
      Text: text,
      VoiceId: "Matthew"
    };
    let firstValue = await client.send(
      new StartSpeechSynthesisTaskCommand(speechParamsAsync)
    );
    console.log(firstValue);
    let taskId = firstValue.SynthesisTask.TaskId;
    console.log(taskId)
    let outputUri = firstValue.SynthesisTask.OutputUri;
    console.log(outputUri)
    synthesizeBtn.innerHTML = "wait";
    // polling takes quite some time. Improvement: test SNS
    const interval = setInterval(async () => {
      let secondValue = await client.send(
        new GetSpeechSynthesisTaskCommand({TaskId: taskId})
      )
      let pollingResponse = secondValue.SynthesisTask.TaskStatus
      console.log(pollingResponse)
      if (pollingResponse == "completed") {
        clearInterval(interval);
        console.log(secondValue);
        document.getElementById('audioSource').src = outputUri;
        document.getElementById('audioPlayback').load();
        synthesizeBtn.innerHTML = "readyyy";
        Rails.ajax({
          url: "/items/persist_mp3_url",
          type: 'POST',
          data: `mp3_url=${outputUri}&id=${itemId}`,
          success: function(data) {
            console.log(data);
          }
        });
      } else if (pollingResponse == "failed") {
        synthesizeBtn.innerHTML = "failed";
      }
    }, 1000);
  };

async function waitUntil(condition) {
  return await new Promise(resolve => {
    const interval = setInterval(() => {
      if (condition) {
        resolve('foo');
        clearInterval(interval);
      };
    }, 1000);
  });
}

  function speakText() {
    if (text.length < 3000) {
      shortText()
    } else if (text.length < 200000) {
      longText()
    } else {
      synthesizeBtn.innerHTML = "text too long";
    }
  };

  synthesizeBtn.addEventListener('click', speakText);
};

export { synthesizeText };
