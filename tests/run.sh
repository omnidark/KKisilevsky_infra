#!/bin/bash

docker exec hw-test bash -c './tests/packer_test.sh'
docker exec hw-test bash -c './tests/terraform_test.sh'
docker exec hw-test bash -c './tests/ansible_test.sh'
