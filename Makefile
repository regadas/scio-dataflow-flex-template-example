PROJECT=<gcp project>
BUCKET=<gcs bucket>
REGION=us-central1

TEMPLATE_PATH=gs://$(BUCKET)/dataflow/templates/flex-wordcount.json
TEMPLATE_IMAGE=gcr.io/$(PROJECT)/dataflow/templates/flex-wordcount:latest

all: run

assembly: 
	sbt assembly

docker-image:
	docker build -t $(TEMPLATE_IMAGE) .
    docker push $(TEMPLATE_IMAGE)

build: assembly docker-image
	
create-template: build
	gcloud beta dataflow flex-template build $(TEMPLATE_PATH) \
  		--image "$(TEMPLATE_IMAGE)" \
  		--sdk-language "JAVA" \
  		--metadata-file "metadata.json"

run: create-template
	gcloud beta dataflow flex-template run "flex-wordcount-`date +%Y%m%d-%H%M%S`" \
  		--template-file-gcs-location "$(TEMPLATE_PATH)" \
  		--region=$(REGION) \
  		--parameters input=gs://dataflow-samples/shakespeare/kinglear.txt  \
  		--parameters output=gs://$(BUCKET)/dataflow/flex-wordcount/output