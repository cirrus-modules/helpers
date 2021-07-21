load("cirrus", environ="env")  # <- avoid name clash for env


def task(name, instance, env={}, instructions=[], depends_on=[], alias=""):
    result = {
        'name': name,
    }
    if env:
        result["env"] = env
    if depends_on:
        result["depends_on"] = depends_on
    if alias != "":
        result['alias'] = alias
    result.update(instance.items())
    for instruction in instructions:
        if instruction:
            result.update(instruction.items())
    return result


def cache(name, folder, fingerprint_script=[], populate_script=[]):
    cache_obj = {'folder': folder}
    if len(fingerprint_script) > 0:
        cache_obj['fingerprint_script'] = fingerprint_script
    if len(populate_script) > 0:
        cache_obj['populate_script'] = populate_script

    return {
        name + '_cache': cache_obj
    }


def script(name, *lines):
    return {
        name + '_script': lines
    }


def artifacts(name, path, type="", format=""):
    result = {
        'path': path,
    }
    if type != "":
        result['type'] = type
    if format != "":
        result['format'] = format
    return {
        name + '_artifacts': result
    }


def container(image="", dockerfile="", cpu=2.0, memory=4096):
    result = dict()
    if image != "":
        result['image'] = image
    if dockerfile != "":
        result['dockerfile'] = dockerfile
    result['cpu'] = cpu
    result['memory'] = memory
    return {
        'container': result
    }


def always(instruction):
    return {'always': instruction}


def on_failure(instruction):
    return {'on_failure': instruction}


def on_success(instruction):
    return {'on_success': instruction}


def github_deep_clone(env=None):
    """Cirrus CI uses go-git for single-branch clones, but some tools might
    expect the '.git' dir to be populated exactly as it is done by default via
    the `git` command.

    This function uses a pre-installed git executable to perform a github clone
    for those use cases.
    """
    env = env or environ  # <- allows overwriting env (facilitates testing)
    pr = env.get("CIRRUS_PR")

    if pr == None or pr == "":
        commands = [
            "git clone --recursive --branch=%(CIRRUS_BRANCH)s https://x-access-token:%(CIRRUS_REPO_CLONE_TOKEN)s@github.com/%(CIRRUS_REPO_FULL_NAME)s.git %(CIRRUS_WORKING_DIR)s" % env,
            "git reset --hard %(CIRRUS_CHANGE_IN_REPO)s" % env,
        ]
    else:
        commands = [
            "git clone --recursive https://x-access-token:%(CIRRUS_REPO_CLONE_TOKEN)s@github.com/%(CIRRUS_REPO_FULL_NAME)s.git %(CIRRUS_WORKING_DIR)s" % env,
            "git fetch origin pull/%(CIRRUS_PR)s/head:pull/%(CIRRUS_PR)s" % env,
            "git reset --hard %(CIRRUS_CHANGE_IN_REPO)s" % env,
        ]
    return script("clone", *commands)
