load("../../../lib.star", "task", "container", "script")

def main(ctx):
    return [
        task("script instruction with single command", container(), instructions=[
            script("single", "echo \"step 1\"")
        ]),
        task("script instruction with multiple commands", container(), instructions=[
            script("multiple", "echo \"step 1\"", "echo \"step 2\"")
        ]),
    ]
