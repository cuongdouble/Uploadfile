Invoke-EflowVmCommand -command 'sudo find /var/lib/docker/containers/ -name \"*-json.log\" -exec grep -l -Pa \"\\x00\" {} + | sudo xargs -r sed -i \"/\\x00/ d\"'
