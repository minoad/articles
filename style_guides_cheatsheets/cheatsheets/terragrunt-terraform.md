# Terragrunt and Terraform Cheat Sheet

## Install

```bash
terraform_latest_version=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | jq -r '.tag_name')
TERRAFORM_VERSION="${terraform_latest_version#v}"
curl -o terraform.zip "https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Get terragrunt
# https://github.com/gruntwork-io/terragrunt/releases/download/v0.57.1/terragrunt_linux_amd64
TERRAGRUNT_VERSION=$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | jq -r '.tag_name')
curl -L -o terragrunt "https://github.com/gruntwork-io/terragrunt/releases/download/$TERRAGRUNT_VERSION/terragrunt_linux_amd64"

# Move terraform and terragrunt to /usr/local/bin
chmod +x terragrunt
sudo mv terragrunt /usr/local/bin/
unzip terraform.zip
sudo mv terraform /usr/local/bin/

# Cleanup
rm terraform.zip
rm terragrunt
```

## Terraform console

1. **Looping**
   - `[for n in vagrant_vm.my_vagrant_vm: n.name]`
```shell
variable "vpcs" {
type = map(object({
   cidr_block = string
}))
}
```

1. ** For each testing in console **
```shell
lookup(map("a","avalue","b","bvalue"), "a")
keys(map("a","avalue","b","bvalue"))
{ for k, v in map("a", "one", "b", "two"): v => k }
keys(map("a","avalue","b","bvalue"))[0] == "a" ? "true" : "false"
keys(map("a","avalue","b","bvalue"))[0] == "ab" ? "true" : "false"
```

1. **Flatten**
   - `flatten([for service_type in yamldecode(file("${path.module}/instances.yaml")): [for host in service_type: {hostname = host.hostname, ip = host.ip, mem = host.mem, cpus=host.cpus, launch_script=host.launch_script}]])`

## Basics:

1. **Terragrunt Commands:**
   - `terragrunt apply`: Apply changes to infrastructure.
   - `terragrunt destroy`: Destroy infrastructure.
   - `terragrunt plan`: Preview changes.
   - `terragrunt output`: Display outputs.
   - `terragrunt validate`: Validate Terraform code.
   - `terragrunt graph`: Generate a visual representation of the dependency graph.

2. **Configuration Files:**
   - `terragrunt.hcl`: Main configuration file.
   - `terraform.tfvars`: Variable definitions file.
   - `terraform.tfstate`: State file.

## Remote State Management:

Remote state management is a crucial aspect of infrastructure as code (IaC) workflows, and Terragrunt provides seamless integration with various remote backends for storing Terraform state files. Storing state remotely offers several advantages, including:

1. **Concurrency Control:**
   - Prevents concurrent modifications by locking the state file during operations.
   - Helps maintain consistency and integrity across collaborative workflows.

2. **State Isolation:**
   - Separates infrastructure state from the Terraform configuration, reducing the risk of accidental deletion or corruption.
   - Enables multiple teams or projects to manage their state independently.

3. **Collaboration:**
   - Facilitates collaboration among team members by centralizing state storage in a shared location.
   - Supports role-based access control (RBAC) to manage permissions effectively.

4. **Backends Supported by Terragrunt:**
   - **Amazon S3:** Utilize AWS S3 buckets as a remote backend.
   - **Azure Storage:** Store state files in Azure Blob Storage.
   - **Google Cloud Storage:** Use GCS buckets for remote state storage.
   - **Terraform Cloud/Enterprise:** Integrate with Terraform Cloud or Terraform Enterprise for advanced state management features.

5. **Configuration Example (S3 Backend):**
   ```hcl
   remote_state {
     backend = "s3"
     config = {
       bucket         = "your-bucket-name"
       key            = "path/to/your/statefile.tfstate"
       region         = "your-aws-region"
       encrypt        = true
       dynamodb_table = "your-dynamodb-table-for-state-locking"
     }
   }


## Dependency Management:

Terragrunt simplifies dependency management between Terraform modules, allowing you to automate the handling of module dependencies and reduce complexity in your infrastructure code. Key aspects of dependency management in Terragrunt include:

1. **Automatic Module Initialization:**
   - Terragrunt automatically initializes modules defined in your configuration, ensuring that dependencies are resolved before executing Terraform operations.
   - Eliminates the need for manual initialization of modules and reduces the risk of configuration errors.

2. **Module Configuration Inheritance:**
   - Terragrunt supports inheritance of configurations across modules, enabling you to define common settings and variables in parent modules and inherit them in child modules.
   - Enhances code reuse and simplifies maintenance by centralizing shared configurations.

3. **Inter-module Variable Passing:**
   - Terragrunt facilitates passing variables between modules, allowing you to propagate inputs and outputs across dependencies.
   - Enables seamless integration between modules without explicit configuration duplication.

4. **Configuration Blocks in Terragrunt:**
   - Use `dependencies` and `dependency` blocks in Terragrunt configuration to define module dependencies explicitly.
   - Specify the path to dependent modules and optional configuration parameters.

5. **Dependency Configuration Example:**
   ```hcl
   dependency "network" {
     config_path = "../network"
   }

5. **Environment Management:**
   - Manage multiple environments (e.g., dev, stage, prod) with ease.
   - Avoid code duplication by using shared configurations.

6. **Encapsulation:**
   - Encapsulate common Terraform configurations into reusable modules.
   - Improves maintainability and reduces redundancy.

## Best Practices:

7. **Use Terragrunt Wrapper Scripts:**
   - Simplifies common tasks and standardizes workflows.
   - Example: `apply-all.sh`, `destroy-all.sh`.

8. **Version Control:**
   - Store Terragrunt configurations along with Terraform code in version control (e.g., Git).
   - Facilitates collaboration and change tracking.

9. **Automated Testing:**
   - Implement automated tests for infrastructure code.
   - Tools like Terratest can be used for unit and integration testing.

10. **Secret Management:**
    - Utilize solutions like HashiCorp Vault or AWS Secrets Manager for secret management.
    - Avoid storing sensitive data in plain text.

## Troubleshooting:

11. **Debugging:**
    - Use `TG_LOG` environment variable for detailed logs (`TG_LOG=debug terragrunt <command>`).
    - Check Terragrunt and Terraform logs for errors.

12. **State Corruption:**
    - Back up state files regularly.
    - Restore from backups in case of corruption or accidental deletion.

13. **Locking Conflicts:**
    - Enable state locking to prevent concurrent modifications.
    - Handle lock contention gracefully.

## Resources:

14. **Official Documentation:** [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs/)
15. **Community Forums:** [Terragrunt Google Group](https://groups.google.com/g/terragrunt)
16. **GitHub Repository:** [Terragrunt GitHub](https://github.com/gruntwork-io/terragrunt)
