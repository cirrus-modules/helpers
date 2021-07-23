load("../../../lib.star", "task", "container", "script", "background")

def main(ctx):
    return [
        task("script instruction with single command", container(), instructions=[
            script("single", "echo \"step 1\"")
        ]),
        task("script instruction with multiple commands", container(), instructions=[
            script("multiple", "echo \"step 1\"", "echo \"step 2\"")
        ]),
        task("background script", container(), instructions=[
            background("start_emulator", "emulator -avd test -no-audio -no-window")
        ])
    ]
