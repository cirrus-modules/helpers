Helper function for creating Cirrus Tasks

# Example

Here is an example of how helper function can be used for generating a [golangci-lint](https://github.com/golangci/golangci-lint) task:

```python
load("github.com/cirrus-modules/helpers", "task", "container", "script", "always", "artifacts")

def main(ctx):
    return [
        task(
            name="Lint",
            instance=container("golangci/golangci-lint:latest", cpu=1.0, memory=512),
            env={
                "STARLARK": True
            },
            instructions=[
                script("lint", "echo $STARLARK", "golangci-lint run -v --out-format json > golangci.json"),
                always(
                    artifacts("report", "golangci.json", type="text/json", format="golangci")
                )
            ]
        )
    ]
```
