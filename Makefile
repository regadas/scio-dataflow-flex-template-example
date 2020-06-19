
region?=us-central1

template_path=gs://$(bucket)/dataflow/templates/flex-wordcount.json
template_image=gcr.io/$(project)/dataflow/templates/flex-wordcount:latest

all: run

assembly: 
	sbt assembly

docker-image:
	docker build -t $(template_image) .
    docker push $(template_image)

build: assembly docker-image
	
create-template: build
	gcloud beta dataflow flex-template build $(template_path) \
  		--image "$(template_image)" \
  		--sdk-language "JAVA" \
  		--metadata-file "metadata.json"

run: create-template
	gcloud beta dataflow flex-template run "flex-wordcount-`date +%Y%m%d-%H%M%S`" \
  		--template-file-gcs-location "$(template_path)" \
  		--region=$(region) \
  		--parameters input=gs://dataflow-samples/shakespeare/kinglear.txt  \
  		--parameters output=gs://$(bucket)/dataflow/flex-wordcount/output