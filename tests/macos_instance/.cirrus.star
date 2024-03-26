load("../../lib.star", "macos_instance", "task")

def main(ctx):
    return [
        task("macos task", macos_instance("big-sur-xcode")),
    ]
