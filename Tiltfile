allow_k8s_contexts('gke-single-cluster')
os.putenv ('DOCKER_BUILDKIT' , '1' )
isWindows = True if os.name == "nt" else False

name = 'registry.contour.thewindyvalley.com/apps/ihs-innerloop'
expected_ref = "%EXPECTED_REF%" if isWindows else "$EXPECTED_REF"
rid = "ubuntu.18.04-x64"
configuration = "Debug"
isWindows = True if os.name == "nt" else False

local_resource(
  'live-update-build',
  cmd= 'dotnet publish --configuration ' + configuration + ' --runtime ' + rid + ' --self-contained false --output ./bin/.buildsync',
  deps=['./bin/' + configuration],
  ignore=['./bin/**/' + rid]
)

custom_build(
        name,
        'docker build . -f Dockerfile -t ' + expected_ref,
        deps=["./bin/.buildsync", ".Dockerfile", "./config"],
        live_update=[
            sync('./bin/.buildsync', '/app'),
            sync('./config', '/app/config'),
        ]
    )

k8s_yaml(['deployment.yaml'])
k8s_resource('ihs-innerloop', port_forwards=[8080,8090,22])