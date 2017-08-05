#!/usr/bin/env python

import argparse
import getpass
import paramiko
from scp import SCPClient
import fileinput
import json
import re
import os

class Ts_object(object):
    def __init__(self, local_dest, remote_path, file_name, md5):
        self.remote_path = remote_path
        self.local_dest = local_dest
        self.file_name = file_name
        self.md5 = md5

def make_ts_object(local_dest, remote_path, file_name, md5):
    ts_object = Ts_object(local_dest, remote_path, file_name, md5)
    return ts_object

def create_ssh_client(server, port, user, password):
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(server, port, user, password)
    return client

def create_all_ts_objects(remote_info_list, ts_file_paths_list):
    server = remote_info_list[0]
    password = remote_info_list[3]
    ssh = create_ssh_client(server, int("22"), "root", password)
    ts_objects = {}
    for i in ts_file_paths_list:
        ts_file_type = i.split("/")[1]
        remote_path = remote_info_list[1].replace("<replace>",ts_file_type)
        cmd_to_execute = "find " + remote_path + i + " -type f"
        ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command(cmd_to_execute)
        for filepath in ssh_stdout.readlines():
            remote_path = filepath.strip('\n')
            local_dest = server + "/" + ts_file_type + remote_path.split(ts_file_type)[2]
            file_name = local_dest.split("/")[-1]
            md5_cmd = "md5sum " + remote_path + " | awk '{print $1}'"
            ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command(md5_cmd)
            md5 = ssh_stdout.readlines()
            ts_objects[filepath] = make_ts_object(local_dest, remote_path, file_name, md5)
    #for key in ts_objects:
    #    print ts_objects[key].md5
    return ts_objects

def download_files(remote_info_list, ts_objects, local_dir):
    #object syntax:
        #self.remote_path
        #self.local_dest
        #self.file_name
        #self.md5 = md5
        #self.server
        #self.password
    server = remote_info_list[0]
    password = remote_info_list[3]
    ssh = create_ssh_client(server, int(22), "root", password)

    if local_dir[-1] != '/':
        local_dir += '/'
    for key in ts_objects:
        target_dest = local_dir + ts_objects[key].local_dest
        target_directory_path = "/".join(target_dest.split("/")[:-1])
        if not os.path.exists(target_directory_path):
            os.makedirs(target_directory_path)
        remote_file = ts_objects[key].remote_path
        local_name = remote_file.split("/")[-1]
        with SCPClient(ssh.get_transport()) as scp:
            scp.get(remote_file)
            os.chmod(local_name, 0755)
            os.rename(local_name, target_dest)
        #cmd = "scp root:" + ts_objects[local_dest].password + "@" + ts_objects[local_dest].server + ":" + ts_objects[local_dest].remote_path + " " + local_dir + ts_objects[local_dest].local_dest
        #print cmd

def get_paths(env):
    config_dict = {
        'tiv_a': [ "webapp01.tiv.att","/share/preview/<replace>/TESTING", "attdvmdev04/cache/default/main/TESTING/WORKAREA/TEST-PREVIEW/" ],
        'stage_a': [ "webapp11.stage.att","share/live/<replace>/NEXTGEN-A", "slti016.sddc.sbc.com/cache/default/main/NEXTGEN-A/WORKAREA/NEXTGEN-A-WORK/" ],
        'stage_b': [ "webapp11.stage.att","share/live/<replace>/NEXTGEN-B", "slti016.sddc.sbc.com/cache/default/main/NEXTGEN-B/WORKAREA/NEXTGEN-B-WORK/" ],
        'prod': [ "webapp11.prod.att","/share/live/<replace>/NEXTGEN", "klph142.kcdc.att.com/cache/default/main/NEXTGEN/WORKAREA/NEXTGEN-WORK/" ],
    }
    password = getpass.getpass("Please enter password for " + config_dict[env][0] + ":\n")
    config_dict[env].append(password)
    return config_dict[env]


def get_user_input(mode):
    environments_available = [ "tiv_a", "stage_a", "stage_b", "prod" ]
    if mode == "compare":
        envs = []
        print "Please enter one of the environments you wish to compare"
        temp_env = raw_input("Available options - %s\n" % (environments_available))
        while temp_env not in environments_available:
            print "Please enter one of the environments you wish to compare"
            temp_env = raw_input("Available options (type carefully) - %s\n" % (environments_available))
        envs.append(temp_env)
        print "Please enter the second environment you wish to compare"
        temp_env2 = raw_input("Available options - %s\n" % (environments_available))
        while temp_env2 not in environments_available or temp_env2 in envs:
            print "Please enter the second environment you wish to compare"
            temp_env2 = raw_input("Available options (type carefully) - %s\n" % (environments_available))
        envs.append(temp_env2)
        return envs
    elif mode == "download":
        envs = []
        #print "Please enter the environment you wish to download from"
        #temp_env = raw_input("Available options - %s\n" % (environments_available))
        temp_env = "tiv_a"
        while temp_env not in environments_available:
            print "Please enter one of the environments you wish to download from"
            temp_env = raw_input("Available options (type carefully) - %s\n" % (environments_available))
        envs.append(temp_env)
        return envs

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    mode_list = ["download", "compare"]
    parser.add_argument('-f', '--file', dest='copy_list', required=True, help="Pass in properly formatted file to use with Teamsite")
    parser.add_argument('-m', '--mode', dest='mode', required=True, help="Modes available %s" % (mode_list))
    parser.add_argument('-d', '--dir', dest='local_dir', required=True, help="local directory where these files will be copied")
    args = parser.parse_args()
    copy_list = args.copy_list
    mode = args.mode
    local_dir = args.local_dir
    envs = get_user_input(mode)
    with open(copy_list, 'r') as infile:
        ts_file_paths_list = infile.read().splitlines()
    if len(envs) == 1:
        remote_info_list = get_paths(envs[0])
        #print remote_info_list
        print "WARNING: Ensure that %s is clear of all TS files to avoid uploading the wrong files to TS." % (local_dir)
        #cont = raw_input("Type 'yes' to continue: ")
        cont = 'yes'
        if cont != 'yes':
            exit(0)
        ts_objects = create_all_ts_objects(remote_info_list, ts_file_paths_list)
        download_files(remote_info_list, ts_objects, local_dir)











