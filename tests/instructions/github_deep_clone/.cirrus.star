load("cirrus", environ="env")
load("../../../lib.star", "task", "container", "github_deep_clone")

def main():
    return [
        _task_with_pr(),
        _task_without_pr()
    ]

def _task_with_pr():
    return task("github_deep_clone with PR", container(), instructions=[
        github_deep_clone()
    ])

def _task_without_pr():
    env = dict(environ)
    env.pop("CIRRUS_PR", None)

    return task("github_deep_clone without PR", container(), instructions=[
        github_deep_clone(env)
    ])
