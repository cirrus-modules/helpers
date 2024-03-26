load("../../lib.star", "container", "task")

def main(ctx):
    return [
        task("task with a default container", container()),
        task("task with a container instantiated from debian:latest image", container("debian:latest")),
        task("task with a container built from Dockerfile", container(dockerfile = "./ci/Dockerfile")),
        task("task with a high-performance container", container(cpu = 16, memory = 16384)),
    ]
