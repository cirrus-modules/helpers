load("cirrus", environ = "env")
load("../../../lib.star", "container", "deep_clone_script", "script", "task")

def main():
    return [
        task_with_pr(),
        task_without_pr(),
        windows_task(),
    ]

def task_with_pr():
    return task("deep_clone_script with PR", container(), instructions = [
        deep_clone_script(),
    ])

def task_without_pr():
    env = dict(environ)
    env.pop("CIRRUS_PR", None)

    return task("deep_clone_script without PR", container(), instructions = [
        deep_clone_script(env = env),
    ])

def windows_task():
    return task(
        name = "Windows (windowsservercore 2019)",
        instance = {
            "windows_container": {
                "image": "python:3.8-windowsservercore",
                "os_version": 2019,
            },
        },
        instructions = [
            deep_clone_script(os = "windows"),
            script("test", "python3 -c 'import sys; print(sys.version)'"),
        ],
    )
