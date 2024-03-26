load("../../../lib.star", "task", "container", "artifacts")

def main(ctx):
    return [
        task("basic artifacts instruction", container(), instructions=[
            artifacts("junit", "junit.xml"),
        ]),
        task("artifacts instruction with type and format", container(), instructions=[
            artifacts("junit", "junit.xml", type="text/xml", format="junit"),
        ]),
    ]
