SOURCE_IMAGE = os.getenv("SOURCE_IMAGE", default='registry.contour.thewindyvalley.com/apps/net-il')
LOCAL_PATH = os.getenv("LOCAL_PATH", default='./src')
NAMESPACE = os.getenv("NAMESPACE", default='default')
NAME = "net-il"

local_resource(
    'build',
    cmd='dotnet publish ./src -c Release --self-contained false -o ./publish',
    deps=['./src'],
    ignore=['./src/obj', './src/bin'],
)

k8s_custom_deploy(
  NAME,
  apply_cmd="tanzu apps workload apply -f ./config/workload.yaml --live-update" +
            " --local-path " + LOCAL_PATH +
            " --source-image " + SOURCE_IMAGE +
            " --namespace " + NAMESPACE +
            " --yes >/dev/null" +
            " && kubectl get workload " + NAME + " -n " + NAMESPACE + " -o yaml",
  delete_cmd="tanzu apps workload delete " + NAME + " -n " + NAMESPACE + " --yes",
  deps=['./publish'],
  container_selector='workload',
  live_update=[
    sync('./publish', '/workspace')
  ]
)

k8s_resource(NAME, port_forwards=["8080:8080"],
            extra_pod_selectors=[{'serving.knative.dev/service': 'net-il'}])

allow_k8s_contexts('gke-single-cluster-linux')