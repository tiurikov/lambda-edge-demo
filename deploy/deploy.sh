terraform init

terraform destroy -auto-approve \
  -var 'dns_zone_id=Z06422981F7CWTB9N85ZA' \
  -var 'dns_name_us=lambda-edge-demo-us-backend.stantiu.people.aws.dev' \
  -var 'dns_name_eu=lambda-edge-demo-eu-backend.stantiu.people.aws.dev'

terraform apply -auto-approve \
  -var 'dns_zone_id=Z06422981F7CWTB9N85ZA' \
  -var 'dns_name_us=lambda-edge-demo-us-backend.stantiu.people.aws.dev' \
  -var 'dns_name_eu=lambda-edge-demo-eu-backend.stantiu.people.aws.dev'