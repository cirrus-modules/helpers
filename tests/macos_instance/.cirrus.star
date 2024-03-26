load("../../lib.star", "task", "macos_instance")

def main(ctx):
    return [
        task("macos task", macos_instance("big-sur-xcode")),
    ]
