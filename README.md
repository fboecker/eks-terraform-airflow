# EKS Terraform Airflow

### Requirements

To use this repository locally you will need the following tools:

- [python 3+](https://www.python.org/downloads/)
- [git](https://git-scm.com/downloads)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [helm 3+](https://helm.sh/docs/intro/install/)
- [awscli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- [terraform 0.13](https://www.terraform.io/downloads.html)


### The Infrastructure

The EKS cluster is deployed using Terraform. If code is pushed to the repo it will automatically get deployed. State is saved in S3. Locks are done in DynamoDB.
AWS access if configured via environmental variables.

If you want to run terraform localy make sure to set the following variables:

* AWS_ACCES_KEY_ID
* AWS_SECRET_ACCESS_KEY
* AWS_DEFAULT_REGION

If these are set you deploy manually with the following command

```bash
terraform init
terraform plan
terraform apply
```

##### Usage

Assuming you have your `~/.aws/credentials` correctly configured.

```bash
export AWS_SDK_LOAD_CONFIG=1 # Tell the sdk from terraform to load the aws config
export AWS_DEFAULT_REGION=eu-west-1 # choose your region
# export AWS_PROFILE=sandbox_role  # Setup a correct AWS_PROFILE if needed
```

##### Create the storage for the terraform state

Terraform needs a place to store the current state of your infrastructure.
Gladly a nice way to store this state is using and S3 bucket and a DynamoDB table.

In the [terraform/backend/](terraform/backend/) directory you can find a set
of terraform templates that create a bucket for you called `bucket=terraform-state-$ACCOUNT_ID` and a dynamodb.

You can create it like this:

```bash
cd backend/
terraform init && terraform apply
```

##### Deploy the infrastructure

After you have you backend storage created, you can deploy the entire infrastructure like this:

```bash
cd ../main/
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export REGION=${AWS_DEFAULT_REGION:-$(aws configure get region)}
terraform init -backend-config="bucket=terraform-state-$ACCOUNT_ID" -backend-config="region=$REGION"
terraform apply
```

After 15-20m the entire infrastructure should be created.
You can now configure your local kubectl to access the new kubernetes cluster.

##### Access the cluster

To be able to access the kubernetes cluster you need to update your kubeconfig:

```bash
$ aws eks update-kubeconfig --region $REGION --name terraform-eks-airflow
...
$ kubectl get pods --all-namespaces
```

```bash
$ kubectl get ingress -n airflow
NAME       HOSTS                  ADDRESS                                                                   PORTS     AGE
airflow   airflow.xxx   ad6efd9329ed411ea8d7d02ae17452ae-1611130781.eu-west-1.elb.amazonaws.com   80, 443   3m18s
```

Now, you can got to your DNS provider and create a CNAME record pointing your domain to the `ADDRESS` of your service.

##### Application deployment

Currently four application get deployed to the cluster

* Airflow
* Nginx ingress controller

They all get deployed using Helm. Configuration per application can be found in kubernetes/APPLICATION_NAME

Pushing to the repo will trigger a deploy/update of the applications.

If you want to run locally you can execute make in the kubernetes/APPLICATION_NAME directory. If you want to deploy all application at once run make in kubernetes directory.

### Github Actions

The cluster and application are automatically deployed using Github Action. The cluster is first build and if that succeeds the applications are getting deployed.

Pipeline configuration can be found at .github/actions

### Airflow DAG's

Airflow checks https://github.com/fboecker/airflow_demo_dags for new DAG's and add them to Airflow.


### ToDo / Next Steps

Read / Check / Implement

* Airflow BasicAuth / RDS / SQS / ALB
* Airflow Kubernetes Executer -> https://airflow.apache.org/docs/1.10.1/kubernetes.html
* K8s Secret -> https://kubernetes.io/docs/concepts/configuration/secret/
* Helm Chart external-dns -> https://github.com/helm/charts/tree/master/stable/external-dns
* Helm Chart clusterautoscaler -> https://github.com/helm/charts/tree/master/stable/cluster-autoscaler
* Terragrunt
* Helmsman -> https://github.com/Praqma/helmsman
* AWS EKS Fargate vs Node Group
* Grafana & Prometheus
* Migrate to GCP
* and something more...