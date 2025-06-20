# Data Engineering Project 

**Data Pipeline on AWS using Terraform** is an implementation of the data pipeline which consumes jobs from Indeed csv file and generates a AWS Quicksight dashboard for analysis.

<!-- TABLE OF CONTENTS -->
## Table of Contents

* [Architecture diagram](#architecture-diagram)
* [How it works](#how-it-works)
    * [Data flow](#data-flow)
* [Prerequisites](#prerequisites)
* [Running project](#running-project)
* [Testing](#testing)
* [Lessons learned](#Lessons learned)
* [License](#license)
* [Contact](#contact)

<!-- ARCHITECTURE DIAGRAM -->
## Architecture diagram

![Architecture](./images/architecture_diagram.png)


<!-- HOW IT WORKS -->
## How it works
This project provisions:
- S3 bucket with 2 folders (raw + processed)
- Athena database
- Lambda ETL job that formats data and runs Athena query
- IAM roles and permissions
- Athena-ready Parquet output
- AWS Quicksights report

#### Data flow
[Upload RAW CSV file to S3]
        |
   (Triggers)
        ↓
[Lambda (Python ETL job)]
    - Register table in Athena
    - Run a CREATE TABLE AS SELECT (CTAS) query (filter, clean)
    - Output to processed S3 folder in paraquet format
        ↓
[Processed Data in S3]
        ↓
[Amazon QuickSight Dashboard]

<!-- PREREQUISITES -->
## Prerequisites
Software required to run the project. Install:
- [Git](https://git-scm.com/downloads)
- [Python 3.8+ (pip)](https://www.python.org/)
- [AWS Cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

<!-- RUNNING PROJECT -->
## Running project
1. Clone this repo:
```run
git clone <this-repo-url>
cd aws_data_project
```
2. Setup AWS Cli
```run
aws config
```
3. Zip Lambda packages
cd lambda
tar -a -c -f csv_to_parquet.zip csv_to_parquet.py

4. Initialize and apply Terraform:
```run
terraform init
terraform apply
```
5. Delete project infrastructure
```run
terraform destroy
```
<!-- TESTING -->
## Testing
*** Test csv to parquet 
Test
{
  "Records": [
    {
      "s3": {
        "object": {
          "key": "raw/dataset_Linkedin_LIX_data-engineer_938003.csv"
        },
        "bucket": {
          "name": "etl-csv-{date}-data-bucket" # Rplace {date} in format YYYYMMDD
        }
      }
    }
  ]
}

<!-- LESSONS LEARNED -->
## Lessons learned
*** TBC

<!-- LICENSE -->
## License
Distributed under the MIT License. See [LICENSE](LICENSE) for more information.

<!-- CONTACT -->
## Contact
Please feel free to contact me if you have any questions.
[Muhammed Salie](https://www.linkedin.com/in/muhammed-salie/) 