# Configuring Storage

By Default, Metering requires persistent storage in two main ways.
The primary storage requirement is to persist data collected by the reporting-operator and store the results of reports. This is usually some form of object storage or distributed file system.

Additionally, Hive metastore requires storage for it's database containing metadata about database tables managed by Presto or Hive. By default, this information is stored in an embedded database called Derby, which keeps it's data on disk in a PersistentVolume, but metastore can also be configured to use an existing Mysql or Postgresql database, instead of Derby. Read the [configuring the Hive metastore documentation][configuring-hive-metastore] for more details.

## Storing data in S3

By default, metering has no stored configured but can be configured to store data in S3.

To use S3 for storage, edit the `spec.storage` section in the example [s3-storage.yaml][s3-storage-config] configuration.
Set the `spec.storage.hive.s3.bucket`, `spec.storage.hive.s3.region` and `spec.storage.hive.s3.secretName` values.
The `bucket` should be the name and optionally the path within the bucket you wish to store metering data at, and the `region` should be the region to create your bucket in.
If you wish to provide an existing bucket, or do not want to provide IAM credentials that have CreateBucket permissions, set `spec.storage.hive.s3.createBucket` to `false` and provide the name of a pre-existing bucket for `spec.storage.hive.s3.bucket`.
The `secretName` should be the name of a secret in the metering namespace containing AWS credentials in the `data.aws-access-key-id` and `data.aws-secret-access-key` fields.

For example:

```
apiVersion: v1
kind: Secret
metadata:
  name: your-aws-secret
data:
  aws-access-key-id: "dGVzdAo="
  aws-secret-access-key: "c2VjcmV0Cg=="
```

To store data in S3, the `aws-access-key-id` and `aws-secret-access-key` credentials must have read and write access to the bucket.
For an example of an IAM policy granting the required permissions see the [aws/read-write.json](aws/read-write.json) file.
If you left `spec.storage.hive.s3.createBucket` set to true, or unset, then you should use [aws/read-write-create.json](aws/read-write-create.json) which contains permissions for creating and deleting buckets.

Please note that this must be done before installation.
Changing these settings after installation will result in broken and unexpected behavior.

## Storing data in Azure

You can also store your data in Azure blob storage, to do so, you must use an existing container.
Edit the `spec.storage` section in the example [azure-storage.yaml][azure-storage-config] configuration.
Set the  `spec.storage.hive.azure.container` and `spec.storage.hive.azure.storageAccountName` value.
`spec.storage.hive.azure.secretAccessKey` must also be set, however, the value can be set with an existing secret. To use an already existing secret, set createSecret to false and leave the two fields blank, with the secret following this format:
```
apiVersion: v1
kind: Secret
metadata:
  name: your-azure-secret
data:
  azure-storage-account-name: "dGVzdAo="
  azure-secret-access-key: "c2VjcmV0Cg=="
```
The `spec.storage.hive.azure.container` should be the container you wish to store metering data at, and the optional `spec.storage.hive.azure.roodDirectory` should be the folder you want your data in, inside the container.
Note that `spec.storage.hive.azure.createSecret` cannot be true with `spec.storage.hive.azure.secretName` non-empty at the same time.
Also note that `spec.storage.hive.azure.storageAccountName` must also be set, even if referencing an existing secret.


## Using shared volumes for storage

Metering has no storage by default, but can use any ReadWriteMany PersistentVolume or [StorageClass][storage-classes] that provisions a ReadWriteMany PersistentVolume.

To use a ReadWriteMany PersistentVolume for storage, modify the [shared-storage.yaml][shared-storage-config] configuration.

You have two options:

1) Set `storage.hive.sharedPVC.createPVC` to true and set the `storage.hive.sharedPVC.storageClass` to the name of a StorageClass with ReadWriteMany access mode. This will use dynamic volume provisioning to have a volume created automatically.
2) Set `storage.hive.sharedPVC.claimName` to the name of an existing ReadWriteMany PVC. This is necessary if you don't have dynamic volume provisioning, or wish to have more control over how the PersistentVolume is created.

> Note: NFS is not recommended to use with Metering.

## Using HDFS for storage (unsupported)

If you do not have access to S3, or storage provisioner that supports ReadWriteMany PVCs, you may also test using HDFS.

HDFS is currently unsupported.
We do not support running HDFS on Kubernetes as it's not very efficient, and has an increased complexity over using object storage.
However, because we historically have used HDFS for development, there are options available within Metering to deploy and use HDFS if you're willing to enable unsupported features.

For more details read [configuring HDFS][configuring-hdfs].

[storage-classes]: https://kubernetes.io/docs/concepts/storage/storage-classes/
[s3-storage-config]: ../manifests/metering-config/s3-storage.yaml
[azure-blob-storage-config]: ../manifests/metering-config/azure-blob-storage.yaml
[shared-storage-config]: ../manifests/metering-config/shared-storage.yaml
[hdfs-storage-config]: ../manifests/metering-config/hdfs-storage.yaml
[configuring-hive-metastore]: configuring-hive-metastore.md
[configuring-hdfs]: configuring-hdfs.md
