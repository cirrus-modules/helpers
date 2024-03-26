load("../../lib.star", "pipe", "script")

def main():
    return pipe(
        "Build Site and Validate Links",
        resources = {"cpu": 2.5, "memory": "5G"},
        steps = {
            "squidfunk/mkdocs-material:latest": script("build", "mkdocs build"),
            "raviqqe/liche:latest": [
                script("validate", "/liche --document-root=site --recursive site/"),
                script("finish", "echo DONE"),
            ],
        },
    )
