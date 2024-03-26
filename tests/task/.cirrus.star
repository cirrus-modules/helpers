load("../../lib.star", "task", "container", "cache", "script", "artifacts", "always", "on_failure", "on_success")

def main(ctx):
    return [
        task("task with a default container", container()),
        task("task with an environment", container(), env={"A": "B"}),
        task("task with a cache instruction", container(), instructions=[cache("node_modules", "node_modules")]),
        task("task with a script instruction", container(), instructions=[
            script("test", "go test -v folder1", "go test -v folder2"),
        ]),
        task("task with an artifacts instruction", container(), instructions=[artifacts("junit", "junit.xml")]),
        task("task with a script that runs always", container(), instructions=[
            always(script("do_always", "true")),
        ]),
        task("task with a script that runs on failure", container(), instructions=[
            on_failure(script("do_on_failure", "true")),
        ]),
        task("task with a script that runs on success", container(), instructions=[
            on_success(script("do_on_success", "true")),
        ]),
    ]
