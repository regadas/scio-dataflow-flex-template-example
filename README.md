# Scio Dataflow flex template example

## Usage

### Setup

```sbt
set gcpProject := "<YOUR PROJECT>"
set gcpRegion := "europe-west1"
```

### Creating the template

```bash
sbt createFlexTemplate
```

Will build the docker image and publish it to [Google Container Registry](https://cloud.google.com/container-registry)

JSON template will be uploaded to `gs://<YOUR PROJECT>/dataflow/templates/flex-template.json`

Example output:

```json
{
    "image": "gcr.io/<YOUR PROJECT>/dataflow/templates/flex-template:0.1.0-SNAPSHOT",
    "metadata": {
        "name": "WordCount Example",
        "parameters": [
            {
                "helpText": "GCS input text file",
                "label": "GCS input text file",
                "name": "input"
            },
            {
                "helpText": "GCS output text file",
                "label": "GCS output text file",
                "name": "output"
            }
        ]
    },
    "sdkInfo": {
        "language": "JAVA"
    }
}
```

### Triggering a run!

```bash
sbt runFlextTemplate input=gs://dataflow-samples/shakespeare/kinglear.txt output=gs://<OUTPUT>
```

⚠️ This is a somewhat opinionated example, check [build.sbt](build.sbt) and modify it to your own needs.