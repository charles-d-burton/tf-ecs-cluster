#!/bin/bash
echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config
echo ECS_ENABLE_TASK_IAM_ROLE=true >> /etc/ecs/ecs.config
echo ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true >> /etc/ecs/ecs.config
mkdir -p /etc/consul.d
mkdir -p /opt/consul

#####
#Consul communication setup, re-enable once consul is running
#####
#cat << EOF > /etc/consul.d/000-consul.json
# {
#  "encrypt": "<some_key>",
#  "server": false,
#  "datacenter": "${region}",
#  "data_dir": "/var/lib/consul",
#  "log_level": "INFO"
#}
#EOF

#docker run -d --restart=always -p 8301:8301 -p 8301:8301/udp -p 8400:8400 -p 8500:8500 -p 53:53/udp\
# -v /opt/consul:/data -v /var/run/docker.sock:/var/run/docker.sock\
# -v /etc/consul.d:/etc/consul.d\
# -h $(curl -s http://169.254.169.254/latest/meta-data/instance-id)\
# --name consul-agent gliderlabs/consul-agent -join "{consul_dns}"\
# -advertise $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)\
# -config-file /etc/consul.d/000-consul.json

#docker run -d --restart=always -v /var/run/docker.sock:/tmp/docker.sock\
# -h $(curl -s http://169.254.169.254/latest/meta-data/instance-id)\
# --name consul-registrator gliderlabs/registrator:latest\
# -ip $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)\
# consul://$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4):8500
