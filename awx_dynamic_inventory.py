#!/usr/bin/python3

# Launched by awx https://awx.example.com/#/inventory_scripts

#   Script first reads all urls of servicecfg for all active locations from
# servers.yml: get_servicecfg_urls()
#   Then, for all locations it reads content of /servicecfg/v1/hosts path.
#   Then construct inventory dicrionary using output from previous step
#   Inventory on the last step of a script will be transformed to json as
# stdout of this script

import json
import os
import sys
import re
import requests
import yaml


def get_servicecfg_urls(etc_servers_path):  # returns <class 'list'> of urls:
    servicecfg_urls = {}
    with open(etc_servers_path) as servers_file:
        try:
             locations_attributes = yaml.safe_load(servers_file)
            #locations_attributes = yaml.load(servers_file, Loader=yaml.FullLoader)
        except yaml.YAMLError:
            print('Error while parsing YAML file: Please correct data and retry.')
            sys.exit()
    for location_attrs in locations_attributes.items():
        if location_attrs[1]['ssh_proxy'] != 'kvmhost':
            servicecfg_urls[location_attrs[0]] = location_attrs[1]['ssh_proxy']
    return servicecfg_urls


def replace_controller(ssh_proxy_url):
    if re.search(r'controller-\d', ssh_proxy_url):
        raise ValueError("ssh_proxy in /etc/servers.yml contains digit. Should be [location]-controller.examle.com")
    return ssh_proxy_url.replace('controller', 'controller-1')


def get_role(entry):
    role = None
    try:
        variables = entry[1]['inventory']['facts']['main']
    except KeyError:
        variables = entry[1]['inventory']['facts']
    for key in variables:
        if key == 'role':
            role = variables[key]
            # print(type(variables['role']))
    if role == 'none':
        return None
    return role


if __name__ == '__main__':
    # Init inventory dictionary, main data structure:
    INVENTORY = {}
    INVENTORY['_meta'] = {'hostvars': {}}
    INVENTORY['all'] = {'children': ['ungrouped']}
    INVENTORY['ungrouped'] = {'children': []}
    INVENTORY['controller'] = { 'hosts' : []}
    
  {
      '_meta' => {
        'hostvars' => {}
      },
      'all' => {
        'children'=> [ 'ungrouped' ]
      },
      'ungrouped' => {
        'children' => []
      }
    }
    
    servers_path = "/etc/servers.yml"
    servers = get_servicecfg_urls(servers_path)

    if os.environ.get('SERVICECFG_USER') is None or os.environ.get('SERVICECFG_PASSWD') is None:
        raise ValueError("ENV SERVICECFG_USER or SERVICECFG_PASSWD is not defined")

    # Fill in inventory dictionary:
    # for item in { 'staging-virginia':'staging-virginia-controller.xstaging.tv'}: #For debug purpose
    for item in servers:
        # init list for group location
        INVENTORY[item] = {'hosts': []}
        try:
            response = requests.get('https://' + servers[item] + '/servicecfg/v1/hosts', auth=(os.environ.get('SERVICECFG_USER'), os.environ.get('SERVICECFG_PASSWD')))
            # response = requests.get('https://example-controller.example.com/servicecfg/v1/hosts', auth=(os.environ.get('SERVICECFG_USER'), os.environ.get('SERVICECFG_PASSWD'))) #For debug purpose
        except requests.exceptions.Timeout:
            continue
        except requests.exceptions.RequestException as e:
            raise SystemExit(e)
        for item2 in response.json()['hosts'].items():

            try:
                if item2[1]['inventory']['enabled']:
                    INVENTORY['_meta']['hostvars'][item2[0]] = item2[1]['inventory']['facts']['main']
                    if 'controller' not in item2[1]['inventory']['facts']['main']['myname']:
                        INVENTORY['_meta']['hostvars'][item2[0]]['ansible_ssh_common_args'] = '-o ProxyCommand="ssh -o StrictHostKeyChecking=no -W %h:%p -q awx-agent@' + replace_controller(servers[item]) + '"'
                    INVENTORY[item]['hosts'].append(item2[0])
                else:
                    INVENTORY['_meta']['hostvars'][item2[0]] = {}
            except KeyError:
                INVENTORY['_meta']['hostvars'][item2[0]] = {}
                continue

            if get_role(item2):
                if item2[1]['inventory']['enabled']:
                    try:
                        INVENTORY[get_role(item2)]['hosts'].append(item2[0])
                    except KeyError:
                        # INVENTORY[get_role(item2)]['hosts'] = []
                        INVENTORY[get_role(item2)] = {'hosts': []}
                        INVENTORY[get_role(item2)]['hosts'].append(item2[0])

                    try:
                        INVENTORY[item + '-' + get_role(item2)]['hosts'].append(item2[0])
                    except KeyError:
                        #INVENTORY[item + '-' + get_role(item2)]['hosts'] = []
                        INVENTORY[item + '-' + get_role(item2)] = {'hosts': []}
                        INVENTORY[item + '-' + get_role(item2)]['hosts'].append(item2[0])

    # Return invetory info:
    print(json.dumps(INVENTORY, sort_keys=True, indent=2))
