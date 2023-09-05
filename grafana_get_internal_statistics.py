#script needs attention to find out how to execute without call trace of grafana-backup pip3 packet
# pylint: disable=trailing-whitespace, assignment-from-no-return, unused-variable, len-as-condition, pointless-string-statement, too-many-arguments, unused-argument, no-else-return, bad-whitespace, line-too-long, import-error, redefined-outer-name, invalid-name, invalid-encoded-data, missing-docstring, superfluous-parens, wrong-import-order
import os
import json
import subprocess
from grafana_backup.dashboardApi import search_dashboard, get_dashboard, search_datasource, search_folders, get_folder
from grafana_backup.commons import to_python2_and_3_compatible_string, print_horizontal_line, left_ver_newer_than_right_ver


def main(args, settings):
    backup_dir = settings.get('BACKUP_DIR')
    timestamp = settings.get('TIMESTAMP')
    limit = settings.get('SEARCH_API_LIMIT')
    grafana_url = settings.get('GRAFANA_URL')
    http_get_headers = settings.get('HTTP_GET_HEADERS')
    verify_ssl = settings.get('VERIFY_SSL')
    client_cert = settings.get('CLIENT_CERT')
    debug = settings.get('DEBUG')
    api_version = settings.get('API_VERSION')

    #Dash metrics:
    is_api_support_page_param = left_ver_newer_than_right_ver(api_version, "6.2.0")
    if is_api_support_page_param:
        save_dashboards_above_Ver6_2(folder_path, log_file, grafana_url, http_get_headers, verify_ssl, client_cert, debug)
    else:
        save_dashboards(folder_path, log_file, limit, grafana_url, http_get_headers, verify_ssl, client_cert, debug)
    #Folder Metrics

    #Datasources Folders
    

def get_all_dashboards_in_grafana(page, limit, grafana_url, http_get_headers, verify_ssl, client_cert, debug):
    (status, content) = search_dashboard(page,
                                         limit,
                                         grafana_url,
                                         http_get_headers,
                                         verify_ssl, client_cert,
                                         debug)
    if status == 200:
        dashboards = content
        print("There are {0} dashboards:".format(len(dashboards)))
        '''for board in dashboards:
           print('name: {0}'.format(to_python2_and_3_compatible_string(board['title'])))'''
        return dashboards
    else:
        print("get dashboards failed, status: {0}, msg: {1}".format(status, content))
        return []


def save_dashboards_above_Ver6_2(folder_path, log_file, grafana_url, http_get_headers, verify_ssl, client_cert, debug):
    limit = 5000 # limit is 5000 above V6.2+
    current_page = 1
    while True:
        dashboards = get_all_dashboards_in_grafana(current_page, limit, grafana_url, http_get_headers, verify_ssl, client_cert, debug)
        print_horizontal_line()
        if len(dashboards) == 0:
            cmd = 'permanent_counter set grafana.dashboards.count ' + str(len(dashboards))
            subprocess.check_output(cmd.split())
            break
        else:
            current_page += 1
        cmd = 'permanent_counter set grafana.dashboards.count ' + str(len(dashboards))
        subprocess.call(cmd, shell=True)
        print_horizontal_line()


def save_dashboards(folder_path, log_file, limit, grafana_url, http_get_headers, verify_ssl, client_cert, debug):
    current_page = 1
    dashboards = get_all_dashboards_in_grafana(current_page, limit, grafana_url, http_get_headers, verify_ssl, client_cert, debug)
    cmd = 'permanent_counter set grafana.dashboards.count ' + str(len(dashboards))
    subprocess.call(cmd, shell=True)
    print_horizontal_line()
