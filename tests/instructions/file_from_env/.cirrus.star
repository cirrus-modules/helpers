load("../../../lib.star", "container", "file_from_env", "task")

def main(ctx):
    return [
        task(
            "test file_from_env",
            container(),
            env = dict(DOCKER_CONFIG = "ENCRYPTED[qwerty]"),
            instructions = [
                file_from_env("DOCKER_CONFIG", "/root/.docker/config"),
            ],
        ),
        task(
            "test named file_from_env",
            container(),
            env = dict(DOCKER_CONFIG = "ENCRYPTED[qwerty]"),
            instructions = [
                file_from_env(
                    name = "mydocker",
                    var = "DOCKER_CONFIG",
                    path = "/root/.docker/config",
                ),
            ],
        ),
    ]
