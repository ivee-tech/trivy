# trivy
Simple image to execute trivy in a script and allow various parameters. 

It uses the trivy tool installed in a docker container with options for trivy tool parameters.

https://github.com/aquasecurity/trivy

The current version trivy version is **0.34.0**

The docker image simply passes the arguments to the trivy tool running in the container.

It allows the scanning of configuration files (Docker, Terraform) or Docker images.

Usage for `trivy image`:

```bash
trivy image  --help
NAME:
   trivy image - scan an image

USAGE:
   trivy image [command options] image_name

OPTIONS:
   --template value, -t value       output template [$TRIVY_TEMPLATE]
   --format value, -f value         format (table, json, template) (default: "table") [$TRIVY_FORMAT]
   --input value, -i value          input file path instead of image name [$TRIVY_INPUT]
   --severity value, -s value       severities of vulnerabilities to be displayed (comma separated) (default: "UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL") [$TRIVY_SEVERITY]
   --output value, -o value         output file name [$TRIVY_OUTPUT]
   --exit-code value                Exit code when vulnerabilities were found (default: 0) [$TRIVY_EXIT_CODE]
   --skip-db-update, --skip-update  skip updating vulnerability database (default: false) [$TRIVY_SKIP_UPDATE, $TRIVY_SKIP_DB_UPDATE]
   --download-db-only               download/update vulnerability database but don't run a scan (default: false) [$TRIVY_DOWNLOAD_DB_ONLY]
   --reset                          remove all caches and database (default: false) [$TRIVY_RESET]
   --clear-cache, -c                clear image caches without scanning (default: false) [$TRIVY_CLEAR_CACHE]
   --no-progress                    suppress progress bar (default: false) [$TRIVY_NO_PROGRESS]
   --ignore-unfixed                 display only fixed vulnerabilities (default: false) [$TRIVY_IGNORE_UNFIXED]
   --removed-pkgs                   detect vulnerabilities of removed packages (only for Alpine) (default: false) [$TRIVY_REMOVED_PKGS]
   --vuln-type value                comma-separated list of vulnerability types (os,library) (default: "os,library") [$TRIVY_VULN_TYPE]
   --security-checks value          comma-separated list of what security issues to detect (vuln,config) (default: "vuln") [$TRIVY_SECURITY_CHECKS]
   --ignorefile value               specify .trivyignore file (default: ".trivyignore") [$TRIVY_IGNOREFILE]
   --timeout value                  timeout (default: 5m0s) [$TRIVY_TIMEOUT]
   --light                          light mode: it's faster, but vulnerability descriptions and references are not displayed (default: false) [$TRIVY_LIGHT]
   --ignore-policy value            specify the Rego file to evaluate each vulnerability [$TRIVY_IGNORE_POLICY]
   --list-all-pkgs                  enabling the option will output all packages regardless of vulnerability (default: false) [$TRIVY_LIST_ALL_PKGS]
   --cache-backend value            cache backend (e.g. redis://localhost:6379) (default: "fs") [$TRIVY_CACHE_BACKEND]
   --skip-files value               specify the file paths to skip traversal [$TRIVY_SKIP_FILES]
   --skip-dirs value                specify the directories where the traversal is skipped [$TRIVY_SKIP_DIRS]
   --help, -h                       show help (default: false)
```

Usage for `trivy config`:

```bash
trivy config  --help
NAME:
   trivy config - scan config files

USAGE:
   trivy config [command options] dir

OPTIONS:
   --template value, -t value                     output template [$TRIVY_TEMPLATE]
   --format value, -f value                       format (table, json, template) (default: "table") [$TRIVY_FORMAT]
   --severity value, -s value                     severities of vulnerabilities to be displayed (comma separated) (default: "UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL") [$TRIVY_SEVERITY]
   --output value, -o value                       output file name [$TRIVY_OUTPUT]
   --exit-code value                              Exit code when vulnerabilities were found (default: 0) [$TRIVY_EXIT_CODE]
   --skip-policy-update                           skip updating built-in policies (default: false) [$TRIVY_SKIP_POLICY_UPDATE]
   --reset                                        remove all caches and database (default: false) [$TRIVY_RESET]
   --clear-cache, -c                              clear image caches without scanning (default: false) [$TRIVY_CLEAR_CACHE]
   --ignorefile value                             specify .trivyignore file (default: ".trivyignore") [$TRIVY_IGNOREFILE]
   --timeout value                                timeout (default: 5m0s) [$TRIVY_TIMEOUT]
   --skip-files value                             specify the file paths to skip traversal [$TRIVY_SKIP_FILES]
   --skip-dirs value                              specify the directories where the traversal is skipped [$TRIVY_SKIP_DIRS]
   --policy value, --config-policy value          specify paths to the Rego policy files directory, applying config files [$TRIVY_POLICY]
   --data value, --config-data value              specify paths from which data for the Rego policies will be recursively loaded [$TRIVY_DATA]
   --policy-namespaces value, --namespaces value  Rego namespaces (default: "users") [$TRIVY_POLICY_NAMESPACES]
   --file-patterns value                          specify file patterns [$TRIVY_FILE_PATTERNS]
   --include-non-failures                         include successes and exceptions (default: false) [$TRIVY_INCLUDE_NON_FAILURES]
   --trace                                        enable more verbose trace output for custom queries (default: false) [$TRIVY_TRACE]
   --help, -h                                     show help (default: false)

```

---
**NOTE**

`trivy config` is not working with templates output.  

---


## Build image and push to docker hub
Use the following command to build the image locally:

```bash
tag='0.34.0'
docker build -t trivy:${tag} -f Dockerfile.ubuntu .
```

Tag the image and push to docker hub:

```bash
tag='0.34.0'
image='trivy'
registry='docker.io'
img="${image}:${tag}"
ns='<ns>' # namespace
docker tag ${img} ${registry}/${ns}/${img}
# requires docker login
docker push ${registry}/${ns}/${img}
```

## Usage

Scan image
```bash
docker run -it -v /var/run/docker.sock:/var/run/docker.sock trivy:0.34.0 image alpine:3.14
```

Scan local home host directory
```bash
docker run -it -v /var/run/docker.sock:/var/run/docker.sock -v ~/:/app/host-home trivy:0.34.0 config ./host-home
```

Scan image and use json format
```bash
docker run -it -v /var/run/docker.sock:/var/run/docker.sock trivy:0.34.0 image alpine:3.14 --format json
```

Scan image, use json format and output file; results stored in ~/data/trivy/results host directory 
```bash
docker run -it -v /var/run/docker.sock:/var/run/docker.sock -v ~/data/trivy/results:/app/results trivy:0.34.0 image alpine:3.14 --format json --output ./results/results.json
```

Scan image, but skip vulnerabilities DB update (possibly required in air-tight environments)
```bash
docker run -it -v /var/run/docker.sock:/var/run/docker.sock trivy:0.34.0 image alpine:3.14 --skib-db-update
```


Scan image ruby:2.4.0 for severity HIGH,CRITICAL and output as JUnit template format in a file; 
results stored in ~/data/trivy/results host directory 
```bash
docker run -it -v /var/run/docker.sock:/var/run/docker.sock -v ~/data/trivy/results:/app/results trivy:0.34.0 image ruby:2.4.0 --format template --template @contrib/junit.tpl --output ./results/results.xml --severity HIGH,CRITICAL
```


Same as above, but output as HTML template format in a file; 
results stored in ~/data/trivy/results host directory 
```bash
docker run -it -v /var/run/docker.sock:/var/run/docker.sock -v ~/data/trivy/results:/app/results trivy:0.34.0 image ruby:2.4.0 --format template --template @contrib/html.tpl --output ./results/results.html --severity HIGH,CRITICAL
```


Scan image ubuntu:20.04 for severity LOW,MEDIUM,HIGH,CRITICAL and use exit code 1; output as JUnit template format in a file; 
results stored in ~/data/trivy/results host directory 
```bash
docker run -it -v /var/run/docker.sock:/var/run/docker.sock -v ~/data/trivy/results:/app/results trivy:0.34.0 image ubuntu:20.04 --format template --template @contrib/junit.tpl --output ./results/results.xml --severity LOW,MEDIUM,HIGH,CRITICAL --exit-code 1
```

Scan other images
``` PowerShell
$image = 'testcgrapp'
$image = 'ktbacr.azurecr.io/zipzapp/zz-app'
$tag = '0.0.1'
$img = "$($image):$($tag)"
$s = $image.Replace('/','_')
docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v C:/Users/daradu/data/trivy/results:/app/results trivy:0.53.0 image $img --format template --template @contrib/junit.tpl --output ./results/results_$s.xml --severity HIGH,CRITICAL --skip-db-update
```

Scan images using private DB repo
``` PowerShell
$image = 'takserver'
$tag = '5.3-RELEASE-24'
$img = "$($image):$($tag)"
$dbRepo = 'ktbacr.azurecr.io/trivy/trivy-db:2'
$s = $image.Replace('/','_')
docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v C:/Data/trivy/results:/app/results `
  -e AZURE_CLIENT_ID=$env:FDPO_TRIVY_DB_SP_CLIENT_ID -e AZURE_CLIENT_SECRET=$env:FDPO_TRIVY_DB_SP_CLIENT_SECRET -e AZURE_TENANT_ID=$env:FDPO_TENANT_ID `
  -e TRIVY_USERNAME=$env:FDPO_TRIVY_DB_SP_CLIENT_ID -e TRIVY_PASSWORD=$env:FDPO_TRIVY_DB_SP_CLIENT_SECRET `
   trivy:0.53.0 image $img --format template --template @contrib/junit.tpl --output ./results/results_$s.xml --severity HIGH,CRITICAL --db-repository $dbRepo
```

## FAQ

**Q: What is the purpose of this project?**  
A: This project provides a Docker container wrapper for Aqua Security's Trivy scanner, allowing you to easily run security scans on container images and configuration files without having to install Trivy directly on your system.

**Q: How is this different from the official Trivy tool?**  
A: This is a containerized version of Trivy that simplifies usage by packaging the tool in a Docker image. It passes all arguments directly to the underlying Trivy tool, making it ideal for CI/CD pipelines and environments where you prefer containerized tools.

**Q: What types of scans can I perform with this container?**  
A: You can scan Docker images for vulnerabilities, scan configuration files (Docker, Terraform), and output results in various formats including JSON, XML (JUnit), HTML, and table formats.

**Q: Do I need Docker to use this tool?**  
A: Yes, this project requires Docker to be installed and running on your system, as it runs Trivy within a Docker container.

