# Installing Operator Metering

Operator Metering is a collection of a few components:

- A Metering Operator Pod which aggregates Prometheus data and generates reports based on the collected usage information.
- Presto and Hive, used by the Operator Metering Pod to perform queries on the collected usage data.

## Prerequisites

Operator Metering requires the following components:

- A Kubernetes v1.11 or newer cluster
- A StorageClass for dynamic volume provisioning. ([See configuring metering][configuring-metering] for more information.)
- A Prometheus installation within the cluster configured to do Kubernetes cluster-monitoring.
    - The prometheus-operator repository's [kube-prometheus instructions][kube-prometheus] are the standard way of achieving Prometheus cluster-monitoring.
    - At a minimum, we require kube-state-metrics, node-exporter, and built-in Kubernetes target metrics.
- 4GB Memory and 4 CPU Cores available cluster capacity.
- Minimum resources needed for the largest single pod is 2 GB of memory and 2 CPU cores.
    - Memory and CPU consumption may often be lower, but will spike when running reports, or collecting data for larger clusters.
- A properly configured kubectl to access the Kubernetes cluster.

In addition, Metering **storage must be configured before proceeding**.
Available storage options are listed in the [configuring storage documentation][configuring-storage].

## Configuration

Before continuing with the installation, please read [Configuring Operator Metering][configuring-metering].
Some options may not be changed post-install, such as storage.
Be certain to configure these options, if desired, before installation.

### Prometheus Monitoring Configuration

For Openshift 3.11, 4.x and later, Prometheus is installed by default through cluster monitoring in the openshift-monitoring namespace, and the default configuration is already setup to use Openshift cluster monitoring.

If you're not using Openshift, then you will need to use the manual install method and customize the [prometheus URL config option][configure-prometheus-url] before proceeding.

## Install Methods

There are multiple installation methods depending on your Kubernetes platform and the version of Operator Metering you want.

### Operator Lifecycle Manager

Using OLM is the recommended option as it ensures you are getting a stable release that we have tested.

OLM is currently only supported on Openshift 4.x.
For instructions on installing using OLM follow the [OLM install guide][olm-install].

### Manual install scripts

Manual installation is generally not recommended unless OLM is unavailable, or if you need to run a custom version of metering rather than what OLM has available.
Please remember that the manual installation method does not guarantee any consistent version or upgrade experience.
For instructions on installing using our manual install scripts follow the [manual installation guide][manual-install].

## Verifying operation

First, wait until the Metering Ansible operator deploys all of the Metering components:

```
kubectl get pods -n $METERING_NAMESPACE -l app=metering-operator -o name | cut -d/ -f2 | xargs -I{} kubectl -n $METERING_NAMESPACE logs -f {} -c metering-operator
```

This can potentially take a minute or two to complete, but when it's done, you should see log output similar the following:

```
{"level":"info","ts":1560984641.7900484,"logger":"runner","msg":"Ansible-runner exited successfully","job":"7911455193145848968","name":"operator-metering","namespace":"metering"}
```

Next, get the list of pods:

```
kubectl -n $METERING_NAMESPACE get pods
```

It may take a couple of minutes, but eventually all pods should have a status of `Running`:

```
NAME                                  READY   STATUS    RESTARTS   AGE
hive-metastore-0                      1/1     Running   0          3m
hive-server-0                         1/1     Running   0          3m
metering-operator-df67bb6cb-6d7vh     2/2     Running   0          4m
presto-coordinator-0                  1/1     Running   0          3m
```

Check the logs of the `reporting-operator` pod for signs of any persistent errors:

```
$ kubectl get pods -n $METERING_NAMESPACE -l app=reporting-operator -o name | cut -d/ -f2 | xargs -I{} kubectl -n $METERING_NAMESPACE logs {} -f
```

## Using Operator Metering

For instructions on using Operator Metering, please see [using Operator Metering][using-metering].

[default-config]: ../manifests/metering-config/default.yaml
[using-metering]: using-metering.md
[configuring-metering]: metering-config.md
[configuring-storage]: configuring-storage.md
[configure-prometheus-url]: metering-config.md#prometheus-connection
[kube-prometheus]: https://github.com/coreos/prometheus-operator/tree/master/contrib/kube-prometheus
[olm-install]: olm-install.md
[manual-install]: manual-install.md
[storage-classes]: https://kubernetes.io/docs/concepts/storage/storage-classes/
