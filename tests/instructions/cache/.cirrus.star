load("../../../lib.star", "task", "container", "cache")

def main(ctx):
    return [
        task("basic cache instruction", container(), instructions=[
            cache("node_modules", "node_modules"),
        ]),
        task("cache instruction with fingerprint script", container(), instructions=[
            cache("node_modules", "node_modules", fingerprint_script="cat package-lock.json"),
        ]),
        task("cache instruction with populate script", container(), instructions=[
            cache("node_modules", "node_modules", populate_script="npm ci"),
        ]),
    ]
