load("../../lib.star", "always", "artifacts", "cache", "container", "on_failure", "on_success", "script", "task")

def main():
    return [
        task("task with a default container", container()),
        task("task with an environment", container(), env = {"A": "B"}),
        task("task with 'allow_failures'", container(), allow_failures = True),
        task("task with 'auto_cancellation'", container(), auto_cancellation = True),
        task("task with 'execution_lock'", container(), execution_lock = "$CIRRUS_BRANCH"),
        task("task with 'only_if'", container(), only_if = "$CIRRUS_BRANCH == 'master'"),
        task("task with 'required_pr_labels' as string", container(), required_pr_labels = "initial-review"),
        task("task with 'required_pr_labels' as list", container(), required_pr_labels = ["initial-review", "ready-for-staging"]),
        task("task with 'skip'", container(), skip = "!changesInclude('.cirrus.yml', '**.{js,ts}')"),
        task("task with 'skip_notifications'", container(), skip_notifications = True),
        task("task with 'stateful'", container(), stateful = True),
        task("task with 'timeout_in'", container(), timeout_in = "90m"),
        task("task with 'trigger_type'", container(), trigger_type = "manual"),
        task("task with a cache instruction", container(), instructions = [cache("node_modules", "node_modules")]),
        task("task with a script instruction", container(), instructions = [
            script("test", "go test -v folder1", "go test -v folder2"),
        ]),
        task("task with an artifacts instruction", container(), instructions = [artifacts("junit", "junit.xml")]),
        task("task with a script that runs always", container(), instructions = [
            always(script("do_always", "true")),
        ]),
        task("task with a script that runs on failure", container(), instructions = [
            on_failure(script("do_on_failure", "true")),
        ]),
        task("task with a script that runs on success", container(), instructions = [
            on_success(script("do_on_success", "true")),
        ]),
    ]
