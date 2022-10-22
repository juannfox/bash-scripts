#/bin/bash
image="docker.io/k0sproject/k0s:v1.25.2-k0s.0"
containers=""
kube_dir="$HOME/.kube"
kube_config="config"
kubeconfig="${kube_dir}/${kube_config}"
docker_k0s_flags="--privileged --cgroupns=host -v /sys/fs/cgroup:/sys/fs/cgroup:rw -v /var/lib/k0s"
controlplane_name="k0s"
worker_name="k0s-worker"
apiserver_port="6443"

function add_controlplane(){
	containers="${containers} ${controlplane_name}"
	run_docker_container ${controlplane_name} "--hostname ${controlplane_name} -p ${apiserver_port}:${apiserver_port} ${docker_k0s_flags} ${image}"
	return $?
}

function add_worker(){
	name="${worker_name}-${1}"
	containers="${containers} ${name}"
	run_docker_container ${name} "--hostname ${name} ${docker_k0s_flags} ${image} k0s worker ${2}"
	return $?
}

function run_docker_container(){
	echo "docker run -d --name ${1} ${2}"
	docker run -d --name ${1} ${2}
	return $?
}

function start_cluster(){
	add_controlplane
	sleep 20
	add_worker 1 $(docker exec -t -i ${controlplane_name} k0s token create --role=worker)
	add_worker 2 $(docker exec -t -i ${controlplane_name} k0s token create --role=worker) 

	set_kubeconfig
	echo done
}

function stop_cluster(){
	containers=$(cat ${kube_dir}/k0s.hosts)
	for container in $containers;do
		docker stop $container
		docker rm $container
	done

	restore_kubeconfig
	echo done
}

function set_kubeconfig(){
	config=$(docker exec ${controlplane_name} cat /var/lib/k0s/pki/admin.conf)
	mkdir -p "${kube_dir}" &> /dev/null
	cp "${kubeconfig}" "${kubeconfig}.old" &> /dev/null
	echo "${config}" > "${kubeconfig}"
	chmod 600 "${kubeconfig}" &> /dev/null
	echo "${containers}" > "${kube_dir}/k0s.hosts"
}

function restore_kubeconfig(){
	cp "${kubeconfig}.old" "${kubeconfig}"
}

function is_docker_running(){
	docker info &> /dev/null
	docker_status=$?
	if [ $docker_status == "1" ];then
		echo "ERROR: Docker daemon must be on for any operations within this K0s launcher."
	fi
	return $docker_status
}

function run_docker(){
	echo "Launching Docker desktop."
	open /Applications/Docker.app
	return $?
}


#Launch
if [[ $1 == "start" ]];then
	if ! is_docker_running;then
		if ! run_docker;then
			echo "ERROR: Could not start Docker desktop."
			exit
		fi
		sleep 10
	fi
	echo "Bootstrapping K0s cluster in Docker."
	start_cluster
elif [[ $1 == "stop" ]];then
	echo "Destroying K0s cluster in Docker."
	stop_cluster
else
	echo "ERROR: No such verb for this K0s launcher."
fi