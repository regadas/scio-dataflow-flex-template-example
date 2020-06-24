
region?=us-central1

template_path=gs://$(project)/dataflow/templates/flex-wordcount.json

all: run

build:
	sbt -Dgcp.project=$(project) docker:publish
	
create-template: build
	gcloud beta dataflow flex-template build $(template_path) \
  		--image `sbt -Dgcp.project=$(project) dockerAlias | tail -n 1 | cut -d' ' -f2` \
  		--sdk-language "JAVA" \
  		--metadata-file "metadata.json"

run: create-template
	gcloud beta dataflow flex-template run "flex-wordcount-`date +%Y%m%d-%H%M%S`" \
  		--template-file-gcs-location "$(template_path)" \
  		--region=$(region) \
  		--parameters input=gs://dataflow-samples/shakespeare/kinglear.txt  \
  		--parameters output=gs://$(project)/dataflow/flex-wordcount/output