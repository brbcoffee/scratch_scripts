#!/usr/bin/env python

import argparse
import getpass
import paramiko
from scp import SCPClient
import fileinput
import json
import re
import os
import time

class Timer:
    def __enter__(self):
        self.start = time.clock()
        return self

    def __exit__(self, *args):
        self.end = time.clock()
        self.interval = self.end - self.start

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
        print i
        ts_file_type = i.split("/")[1]
        remote_path = remote_info_list[1].replace("<replace>",ts_file_type)
        cmd_to_execute = "find " + remote_path + i + " ! -name '*.gz' -type f"
        ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command(cmd_to_execute)
        for filepath in ssh_stdout.readlines():
            remote_path = filepath.strip('\n')
            if verbose:
                print remote_path
            local_dest = server + "/" + ts_file_type + remote_path.split(ts_file_type)[2]
            file_name = local_dest.split("/")[-1]
            md5_cmd = "md5sum " + remote_path + " | awk '{print $1}'"
            ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command(md5_cmd)
            md5 = ssh_stdout.readlines()
            ts_object_dict_key = "/" + ts_file_type + remote_path.split(ts_file_type)[2]
            ts_objects[ts_object_dict_key] = make_ts_object(local_dest, remote_path, file_name, md5)
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

def get_paths(env):
    config_dict = {
        'tiv_a': [ "webapp01.tiv.att","/share/preview/<replace>/TESTING", "attdvmdev04/cache/default/main/TESTING/WORKAREA/TEST-PREVIEW/" ],
        'stage_a': [ "webapp11.stage.att","/share/live/<replace>/NEXTGEN-A", "slti016.sddc.sbc.com/cache/default/main/NEXTGEN-A/WORKAREA/NEXTGEN-A-WORK/" ],
        'stage_b': [ "webapp11.stage.att","/share/live/<replace>/NEXTGEN-B", "slti016.sddc.sbc.com/cache/default/main/NEXTGEN-B/WORKAREA/NEXTGEN-B-WORK/" ],
        'prod_a': [ "webapp11.prod.att","/share/teamsite/leg_a/<replace>/NEXTGEN", "klph142.kcdc.att.com/cache/default/main/NEXTGEN/WORKAREA/NEXTGEN-WORK/" ],
        'prod_b': [ "webapp11.prod.att","/share/teamsite/leg_b/<replace>/NEXTGEN", "klph142.kcdc.att.com/cache/default/main/NEXTGEN/WORKAREA/NEXTGEN-WORK/" ],
    }
    password = getpass.getpass("Please enter password for " + config_dict[env][0] + ":\n")
    config_dict[env].append(password)
    return config_dict[env]


def get_user_input(mode):
    environments_available = [ "tiv_a", "stage_a", "stage_b", "prod_a", "prod_b" ]
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
        print "Please enter the environment you wish to download from"
        temp_env = raw_input("Available options - %s\n" % (environments_available))
        while temp_env not in environments_available:
            print "Please enter one of the environments you wish to download from"
            temp_env = raw_input("Available options (type carefully) - %s\n" % (environments_available))
        envs.append(temp_env)
        return envs

def files_not_present(array_of_ts_objects, envs):
    dict1 = array_of_ts_objects[0]
    dict2 = array_of_ts_objects[1]
    env1 = envs[0]
    env2 = envs[1]
    for dict1_keys, dict1_values in dict1.iteritems():
        try:
            tmp = dict2[dict1_keys]
        except KeyError:
            print "%s not present in %s" % (dict1_keys, env2)
    for dict2_keys, dict2_values in dict2.iteritems():
        try:
            tmp = dict1[dict2_keys]
        except KeyError:
            print "%s not present in %s" % (dict2_keys, env1)

def compare_objects(array_of_ts_objects, envs):
    dict1 = array_of_ts_objects[0]
    dict2 = array_of_ts_objects[1]
    env1 = envs[0]
    env2 = envs[1]
    for dict1_keys, dict1_values in dict1.iteritems():
        try:
            if dict1_values.md5 == dict2[dict1_keys].md5:
                if verbose:
                    print "Match! %s" % (dict1_keys)
            elif dict1_values.md5 != dict2[dict1_keys].md5:
                print "MD5 Error! %s" % (dict1_keys)
        except KeyError:
            pass
            #mentioned in files not present function so don't need redundant warning
            #print "%s missing from %s" % (dict1[dict1_keys].remote_path, env2)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    mode_list = ["download", "compare"]
    parser.add_argument('-f', '--file', dest='copy_list', required=True, help="Pass in properly formatted file to use with Teamsite")
    parser.add_argument('-m', '--mode', dest='mode', required=True, help="Modes available %s" % (mode_list))
    parser.add_argument('-d', '--dir', dest='local_dir', required=True, help="local directory where these files will be copied")
    parser.add_argument('-v', '--verbose', action='store_true', help="to print verbose output")
    args = parser.parse_args()
    copy_list = args.copy_list
    mode = args.mode
    local_dir = args.local_dir
    verbose = args.verbose
    envs = get_user_input(mode)
    with open(copy_list, 'r') as infile:
        ts_file_paths_list = infile.read().splitlines()
    array_of_ts_objects = []
    i = 0
    while i < len(envs):
        remote_info_list = get_paths(envs[i])
        if verbose:
            print remote_info_list
            ts_objects = {}
            print "Creating objects - %s" % envs[i]
            with Timer() as t:
                ts_objects = create_all_ts_objects(remote_info_list, ts_file_paths_list)
            print "Number of objects created: %s" % (len(ts_objects.keys()))
            print('Request took %.03f sec.' % t.interval)
        else:
            print "Creating objects"
            ts_objects = create_all_ts_objects(remote_info_list, ts_file_paths_list)
        array_of_ts_objects.append(ts_objects)
        i += 1

    if mode == "download":
        #print remote_info_list
        print "WARNING: Ensure that %s is clear of all TS files to avoid uploading the wrong files to TS." % (local_dir)
        #cont = raw_input("Type 'yes' to continue: ")
        cont = 'yes'
        if cont != 'yes':
            exit(0)
        download_files(remote_info_list, ts_objects, local_dir)
    elif mode == "compare":
        files_not_present(array_of_ts_objects, envs)
        print "this is probably nothing new, sigh."
        compare_objects(array_of_ts_objects, envs)