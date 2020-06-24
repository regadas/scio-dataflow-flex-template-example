# Scio Dataflow flex template example

## Usage

Run `make project=$GCP_PROJECT [region=us-central1]` to build, create and run the template.

* builds & publishes docker image with `gcr.io/${project}/dataflow/templates/flex-template:VERSION` tag.
    
    ```bash
    sbt docker:publish
    ```

* creates the `flex-template`

    ```bash
    gcloud beta dataflow flex-template build $(template_path) \
        --image `sbt -Dgcp.project=$(project) dockerAlias | tail -n 1 | cut -d' ' -f2` \
        --sdk-language "JAVA" \
        --metadata-file "metadata.json"
    ```

* triggers a job run
    
    ```bash
    gcloud beta dataflow flex-template run "flex-wordcount-`date +%Y%m%d-%H%M%S`" \
        --template-file-gcs-location "$(template_path)" \
        --region=$(region) \
        --parameters input=gs://dataflow-samples/shakespeare/kinglear.txt  \
        --parameters output=gs://$(project)/dataflow/flex-wordcount/output
    ```

⚠️ This is a somewhat opinionated example, modify it to your own needs.