### Generate certificates for Minio 

```console
$ mkdir -p ${HOME}/.minio/certs
$ cp public-key.cert ${HOME}.minio/certs/public.crt          # public.crt is the public certificate with the Minio servers DNS name
$ sudo cp private-key.key ${HOME}/.minio/certs/private.key   # private.key is the private key fow the above certificate
```

### Enable Minio

* Create the data storage folder and start the server.

``` console
$ mkdir -p ${HOME}/data
$ minio server ${HOME}/data  
No credential environment variables defined. Going with the defaults.
It is strongly recommended to define your own credentials via environment variables MINIO_ROOT_USER and MINIO_ROOT_PASSWORD instead of using default values
Endpoint: https://10.197.107.61:9000  ....
RootUser: minioadmin
RootPass: minioadmin

Browser Access:
   https://10.197.107.61:9000  ...
   
Command-line Access: https://docs.min.io/docs/minio-client-quickstart-guide
   $ mc alias set myminio https://10.197.107.61:9000 minioadmin minioadmin

Object API (Amazon S3 compatible):
   Go:         https://docs.min.io/docs/golang-client-quickstart-guide
   Java:       https://docs.min.io/docs/java-client-quickstart-guide
   Python:     https://docs.min.io/docs/python-client-quickstart-guide
   JavaScript: https://docs.min.io/docs/javascript-client-quickstart-guide
   .NET:       https://docs.min.io/docs/dotnet-client-quickstart-guide

Certificate:
    Signature Algorithm: SHA512-RSA
    Issuer: .....
    Validity
        Not Before: Thu, 01 Jul 2021 01:38:22 GMT
        Not After : Sun, 29 Jun 2031 01:38:22 GMT

Detected default credentials 'minioadmin:minioadmin', please change the credentials immediately by setting 'MINIO_ROOT_USER' and 'MINIO_ROOT_PASSWORD' environment values
IAM initialization complete
```
* Create a bucket e.g. `test-bucket`. This can be completed by login in to the Minio browser and creating the bucket. 

### Enable backup protection on TMC

* Create the required credentials.
* Create the `Customer provisioned S3-compatible storage` end-point within the TMC interface. Use `minio` as the region. 
* Enable `Data protection on the workload cluster`

### Update Velero setting for root CA

* While logged in to the workload cluster, edit and update the following object - 
```console
$ kubectl edit backupstoragelocations.velero.io -n velero NAME_OF_S3_COMPATABILE_STORAGE
```
Add the base64 encoded root CA `caCert` and update the object.

```yaml
spec:
  config:
    bucket: test-bucket
    profile: NAME_OF_S3_COMPATABILE_STORAGE
    publicUrl: https://10.197.107.61:9000
    region: minio
    s3ForcePathStyle: "true"
    s3Url: https://10.197.107.61:9000
  objectStorage:
    bucket: test-bucket
    caCert: LS0tLS1CRUdJTiBDRRU4wQkxJMWE...ElGSUNBVEUtLS0tLQo=
    prefix: 01F9FNY05068P4KSCM15M26S9G/
  provider: aws
status:
  lastSyncedTime: "2021-07-01T01:53:50.342904668Z"
```  

