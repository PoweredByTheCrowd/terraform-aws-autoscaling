from __future__ import print_function

import base64
import json
import os
import requests
import time
import boto3
from requests.auth import HTTPBasicAuth


__version__ = '0.1.0'


def _remove_containers(host, auth):
    url = host['links']['instances']
    res = requests.get(url, auth=auth)
    res_data = res.json()
    if res_data['data'] and len(res_data['data']) > 0:
        for container in res_data['data']:
            url = container['links']['self'] + '/?action=stop'
            res = requests.post(url, auth=auth, data={
                "remove": True,
                "timeout": 0
            })


def _delete_host(host, auth):
    # First deactivate the host
    url = host['links']['self']
    res = requests.post(url + '/?action=deactivate', auth=auth)

    # Wait for host to be inactive
    res = requests.get(url, auth=auth)
    res_data = res.json()
    state = res_data['state']
    count = 0
    while state != 'inactive' and count < 60:
        res = requests.get(url, auth=auth)
        count += 1
        time.sleep(0.5)

    # Now remove the host
    res = requests.post(url + '/?action=remove', auth=auth)


def lambda_handler(event, context):
    print("Starting ...")
    print("event received", event)
    rancher_api_url = os.getenv('RANCHER_URL')
    access_key = os.getenv('RANCHER_ACCESS_KEY', None)
    secret_key = os.getenv('RANCHER_SECRET_KEY', None)
    message = json.loads(event['Records'][0]['Sns']['Message'])

    if message['LifecycleTransition'] != 'autoscaling:EC2_INSTANCE_TERMINATING':
        return
    if access_key is None or secret_key is None:
        print("ERROR: Invalid Rancher keys")
        return

    instance_id = message['EC2InstanceId']
    instance_hostname = get_hostname_from_instance(instance_id=instance_id)
    auth = HTTPBasicAuth(access_key, secret_key)
    # Load the hosts from rancher and find the one whose label
    # spotinst.instanceId matches the instance_id from the message
    res = requests.get(rancher_api_url + "/hosts", auth=auth)
    res_data = res.json()
    print('Instance {0} is to be removed'.format(instance_id))
    if res_data['data'] and len(res_data['data']) > 0:
        for host in res_data['data']:
            print("inspecting: ", host['hostname'])
            if host['hostname'] == instance_hostname:
                # print('Removing containers from host {0}'.format(host['id']))
                # _remove_containers(host, auth=auth)

                print ('Removing host {0}, id {1}'.format(host['id'], host['hostname']))
                _delete_host(host, auth=auth)
                break

    print("done")


def get_hostname_from_instance(instance_id):
    ec2 = boto3.resource('ec2')
    instance = ec2.Instance(instance_id)
    return instance.private_dns_name


if __name__ == "__main__":
    event = {
        'Records': [
            {
                'Sns': {
                    'Message': "{ \
                        \"rancher_project_id\": \"1a8\", \
                        \"instance_id\": \"ip-172-24-3-134.eu-west-1.compute.internal\", \
                        \"event\": \"AWS_EC2_INSTANCE_TERMINATED\" \
                    }"
                }
            }
        ]
    }
    lambda_handler(event, None)