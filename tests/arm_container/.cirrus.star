load("../../lib.star", "arm_container", "task")

def main(ctx):
    return [
        task("task with a default ARM container", arm_container()),
        task("task with a container instantiated from debian:latest image", arm_container("debian:latest")),
        task("task with a container built from Dockerfile", arm_container(dockerfile = "./ci/Dockerfile")),
        task("task with a high-performance container", arm_container(cpu = 16, memory = 16384)),
    ]
