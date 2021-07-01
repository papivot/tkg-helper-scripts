## Generate certificates for Minio 

```console
$ mkdir -p ${HOME}/.minio/certs
$ cp public-key.cert ${HOME}.minio/certs/public.crt                                                                                                                                                                      ─╯
$ sudo cp private-key.key ${HOME}/.minio/certs/private.key
```

Create the data storage folder and start the server

``` console
$ mkdir -p ${HOME}/data
$ minio server /home/nverma/data                                                                                                                                                                                                                ─╯
No credential environment variables defined. Going with the defaults.
It is strongly recommended to define your own credentials via environment variables MINIO_ROOT_USER and MINIO_ROOT_PASSWORD instead of using default values
Endpoint: https://10.197.107.61:9000  https://172.17.0.1:9000  https://192.168.100.1:9000  https://192.168.102.1:9000  https://192.168.104.1:9000  https://127.0.0.1:9000
RootUser: minioadmin
RootPass: minioadmin

Browser Access:
   https://10.197.107.61:9000  https://172.17.0.1:9000  https://192.168.100.1:9000  https://192.168.102.1:9000  https://192.168.104.1:9000  https://127.0.0.1:9000

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

En
