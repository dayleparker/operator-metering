# Operator Metering

- [Installing Metering](install-metering.md)
  - [Kubernetes install using Operator Lifecycle Manager](olm-install.md)
  - [Manual install scripts](manual-install.md)
- [Metering configuration options](metering-config.md)
  - [common configuration options](common-configuration.md)
    - [pod resource requests and limits](common-configuration.md#resource-requests-and-limits)
    - [node selectors](common-configuration.md#node-selectors)
    - [image repositories and tags](common-configuration.md#image-repositories-and-tags)
  - [configuring reporting-operator](configuring-reporting-operator.md)
    - [set the Prometheus URL](configuring-reporting-operator.md#prometheus-url)
    - [exposing the reporting API](configuring-reporting-operator.md#exposing-the-reporting-api)
    - [configuring Authentication on Openshift](configuring-reporting-operator.md#openshift-authentication)
  - [configuring storage](configuring-storage.md)
    - [storing data in s3](configuring-storage.md#storing-data-in-s3)
    - [storing data in a ReadWriteMany PVC](configuring-storage.md#using-shared-volumes-for-storage)
  - [configuring the Hive metastore](configuring-hive-metastore.md)
  - [configuring aws billing correlation for cost correlation](configuring-aws-billing.md)
  - [configuring for use with Telemeter](configuring-telemeter.md)
- [Using Metering](using-metering.md)
- [Resource Tuning](tuning.md)
- [Troubleshooting](troubleshooting-metering.md)
- [Writing Custom Queries Guide](writing-custom-queries.md)
- [Debugging](dev/debugging.md)
- [Developer Guide](dev/developer-guide.md)
- [Architecture](metering-architecture.md)

Custom Resources:

- [Reports](reports.md)
  - [Roll-up Reports](rollup-reports.md)
- [ReportQueries](reportqueries.md)
- [ReportDataSources](reportdatasources.md)
- [StorageLocations](storagelocations.md)

