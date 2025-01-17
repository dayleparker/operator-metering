# Manual Installation using Operator Lifecycle Manager (OLM)

Currently Metering via OLM is only supported on Openshift 4.x via the Openshift Marketplace.
If you want to install metering into a non-Openshift Kubernetes cluster, please use the [manual installation documentation][manual-install].

## Install

This will cover installing the metering-operator via the openshift-marketplace using `kubectl`/`oc` and will then create a Metering resource defining the configuration for the metering-operator to use to install the rest of the Metering stack.

### Install Metering Operator

Installing the metering-operator is done by creating a `Subscription` resource in a namespace with a `CatalogSource` containing the `metering` package.

Currently we require that metering is installed into its own namespace which requires some setup.

First, start by creating the `openshift-metering` namespace:

```
kubectl create ns openshift-metering
```

Next a `CatalogSourceConfig` needs to be added to the `openshift-marketplace` namespace.
This results in a `CatalogSource` containing the `metering` OLM package being created in the `openshift-metering` namespace.

Download the `metering-operators` [metering.catalogsourceconfig.yaml][metering-catalogsourceconfig] and install it into the `openshift-marketplace` namespace:

```
kubectl apply -n openshift-marketplace -f metering.catalogsourceconfig.yaml
```

After it is created, confirm a new `CatalogSource` is created in the `openshift-metering` namespace:

```
kubectl -n openshift-metering get catalogsources
NAME                 NAME     TYPE   PUBLISHER   AGE
metering-operators   Custom   grpc   Custom      7s
```

You should also see a pod with a name resembling `metering-operators-12345` in the `openshift-marketplace` namespace, this pod is the package registry pod OLM will use to get the `metering` package contents:

```
kubectl -n openshift-marketplace get pods
NAME                                    READY   STATUS    RESTARTS   AGE
certified-operators-77b9986c5f-b7ndr    1/1     Running   0          25m
community-operators-7d57677987-88477    1/1     Running   0          25m
marketplace-operator-77dd7759cc-4thqm   1/1     Running   0          25m
metering-operators-784f4ccccc-ctdxd     1/1     Running   0          43s
redhat-operators-569bcbb8c5-7v2kw       1/1     Running   0          25m
```

Next, you will create an `OperatorGroup` in your namespace that restricts the namespaces the operator will monitor to the `openshift-metering` namespace.

Download the `metering-operators` [metering.operatorgroup.yaml][metering-operatorgroup] and install it into the `openshift-metering` namespace:

```
kubectl -n openshift-metering apply -f metering.operatorgroup.yaml
```

Lastly, create a `Subscription` to install the metering-operator.

Download the [metering.subscription.yaml][metering-subscription] and install it into the `openshift-metering` namespace:


```
kubectl -n openshift-metering apply -f metering.subscription.yaml
```

Once the subscription is created, OLM will create all the required resources for the metering-operator to run.
This step takes a bit longer than others, within a few minutes the metering-operator pod should be created.
Verify the metering-operator has been created and is running:

```
kubectl -n openshift-metering get pods
NAME                                READY   STATUS    RESTARTS   AGE
metering-operator-c7545d555-h5m6x   2/2     Running   0          32s
```

### Install Metering

Once the metering-operator is installed, we can now use it to install the rest of the Metering stack by configuring a `MeteringConfig` CR.

#### Configuration

All of the supported configuration options are documented in [configuring metering][configuring-metering].
In this document, we will refer to your configuration as your `metering.yaml`.

To start, download the example [default.yaml][default-config] `MeteringConfig` resource and save it as `metering.yaml`, and make any additional customizations you require.

#### Install Metering Custom Resource

To install all the components that make up Metering, install your `metering.yaml` into the cluster:

```
kubectl -n openshift-metering apply -f metering.yaml
```

Within a minute you should see resources being created in your namespace:

```
kubectl -n openshift-metering get pods
NAME                                  READY   STATUS              RESTARTS   AGE
hdfs-datanode-0                       0/1     Init:0/1            0          25s
hdfs-namenode-0                       0/1     ContainerCreating   0          25s
hive-metastore-0                      0/1     ContainerCreating   0          25s
hive-server-0                         0/1     ContainerCreating   0          25s
metering-operator-c7545d555-h5m6x     2/2     Running             0          105s
metering-operators-bvpf7              1/1     Running             0          2m33s
presto-coordinator-584789c6b-kpfpc    0/1     Init:0/1            0          25s
reporting-operator-5c8db66985-9ghz4   0/1     Running             0          25s
```

It can take several minutes for all the pods to become "Ready".
Many pods rely on other components to function before they themselves can be considered ready.
Some pods may restart if other pods take too long to start, this is okay and can be expected during installation.

Eventually your pod output should look like this:

```
NAME                                  READY   STATUS    RESTARTS   AGE
hdfs-datanode-0                       1/1     Running   0          7m24s
hdfs-namenode-0                       1/1     Running   0          7m24s
hive-metastore-0                      1/1     Running   0          7m24s
hive-server-0                         1/1     Running   1          7m24s
metering-operator-c7545d555-h5m6x     2/2     Running   0          8m44s
metering-operators-bvpf7              1/1     Running   0          9m32s
presto-coordinator-584789c6b-kpfpc    1/1     Running   0          7m24s
reporting-operator-5c8db66985-9ghz4   1/1     Running   0          7m24s
```

Once all pods are ready, you can begin using Metering to collect and Report on your cluster.
For further reading on using metering, see the [using metering documentation][using-metering]

[manual-install]: manual-install.md
[metering-catalogsourceconfig]: ../manifests/deploy/openshift/olm/metering.catalogsourceconfig.yaml
[metering-operatorgroup]: ../manifests/deploy/openshift/olm/metering.operatorgroup.yaml
[metering-subscription]: ../manifests/deploy/openshift/olm/metering.subscription.yaml
[configuring-metering]: metering-config.md
[default-config]: ../manifests/metering-config/default.yaml
[using-metering]: using-metering.md
