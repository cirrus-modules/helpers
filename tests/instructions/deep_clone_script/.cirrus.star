load("cirrus", environ="env")
load("../../../lib.star", "task", "container", "deep_clone_script")

def main():
    return [
        _task_with_pr(),
        _task_without_pr()
    ]

def _task_with_pr():
    return task("deep_clone_script with PR", container(), instructions=[
        deep_clone_script()
    ])

def _task_without_pr():
    env = dict(environ)
    env.pop("CIRRUS_PR", None)

    return task("deep_clone_script without PR", container(), instructions=[
        deep_clone_script(env=env)
    ])
