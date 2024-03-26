load("cirrus", environ = "env")
load("../../../lib.star", "script", "task", "use_deep_clone")

def main():
    return [
        use_deep_clone(windows_task()),
        use_deep_clone(linux_task(), before = "test_script"),
    ]

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
            script("test", "python3 -c 'import sys; print(sys.version)'"),
        ],
    )

def linux_task():
    return task(
        name = "Linux (debian buster)",
        instance = {
            "container": {"image": "python:3.8-buster"},
        },
        instructions = [
            script("prepare", "python3 -m pip install -U pip setuptools"),
            script("test", "python3 -c 'import sys; print(sys.version)'"),
        ],
    )
