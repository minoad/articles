"""A Python Pulumi program"""
# source venv/bin/activate

import sys

import debugpy
import pulumi
import pulumi_docker as docker

# debugpy.listen(5678)
# debugpy.wait_for_client()
# debugpy.breakpoint()
# import yaml

# with open("Pulumi.dev.yaml", "r") as f:
#     variables = yaml.safe_load(f)

STACK = pulumi.get_stack()
# Get configuration values
config = pulumi.Config()

config.get("backendPort")

frontend_port = config.require_int("frontendPort")
backend_port = config.require_int("backendPort")
mongo_port = config.require_int("mongoPort")


def get_images():
    images = {
        "frontend_image": "pulumi/tutorial-pulumi-fundamentals-frontend:latest",
        "backend_image": "pulumi/tutorial-pulumi-fundamentals-backend:latest",
        "mongo_image": "pulumi/tutorial-pulumi-fundamentals-database-local:latest"
    }
    images = [docker.RemoteImage(image, name=images[image]) for image in images.keys()]
    return images

def create_network():
    network = docker.Network("network", name=f"services_{STACK}")
    
def main():
    images = get_images()
    network = create_network()
    # deploy_docker_container()
    print('a')


if __name__ == "__main__":
    sys.exit(main())
