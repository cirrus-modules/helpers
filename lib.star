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


def pipe(name, steps=(), resources=None):
    """Create a Docker Pipe that executes each instruction in its own container
    https://cirrus-ci.org/guide/docker-pipe/

    `steps` should be a dict: each key is a Docker image name its associated
    value is a list of instructions. When repeated images are required an
    equivalent list of 2-tuples, (similar to `dict.items()`) can also be used.
    """
    spec = {'name': name}
    if resources != None:
        spec['resources'] = resources

    steps_list = steps.items() if type(steps) == "dict" else steps
    spec['steps'] = []
    for image, instructions in steps_list:
        step = {'image': image}
        items = [instructions] if type(instructions) != "list" else instructions
        for item in items:
            step.update(item)
        spec['steps'].append(step)
    return {'pipe': spec}


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
    if len(lines) > 0:
        return {name + '_script': lines}
    return {'script': name}


def background(name, *lines):
    """Variation of `script`, but runs in background
    https://cirrus-ci.org/guide/writing-tasks/#background-script-instruction
    """
    if len(lines) > 0:
        return {name + '_background_script': lines}
    return {'background_script': name}


def powershell(name, *lines):
    """Variation of `script`, but uses PowerShell for Windows containers.
    https://cirrus-ci.org/guide/windows/#powershell-support
    """
    if len(lines) == 0:
        return {'script': [{"ps": name}]}

    instructions = [{"ps": l} for l in lines]
    return {name + '_script': instructions}


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


def file_from_env(var, path, name=""):
    """Create a file from an environment variable (specially useful with encrypted vars).
    This function automatically derives the instruction name from the variable name
    (e.g.: `var=SERVER_CONFIG` will create a `server_config_file` instruction),
    unless the `name` argument is given (e.g. `name=servercfg` will create a `servercfg_file` instruction).
    https://cirrus-ci.org/guide/writing-tasks/#file-instruction
    """
    name = var.lower() if name == "" else name
    return {
        ("%s_file" % name): {
            "path": path,
            "variable_name": var
        }
    }


def container(image="", dockerfile="", cpu=2.0, memory=4096, **kwargs):
    """https://cirrus-ci.org/guide/linux"""
    result = dict()
    if image != "":
        result['image'] = image
    if dockerfile != "":
        result['dockerfile'] = dockerfile
    result['cpu'] = cpu
    result['memory'] = memory
    result.update(kwargs)
    return {
        'container': result
    }


def windows_container(image="cirrusci/windowsservercore", os_version="", **kwargs):
    """https://cirrus-ci.org/guide/windows"""
    spec = {"image": image}
    if os_version != "":
        spec["os_version"] = os_version
    spec.update(kwargs)
    return {"windows_container": spec}


def macos_instance(image, **kwargs):
    """https://cirrus-ci.org/guide/macOS"""
    spec = {"image": image}
    spec.update(kwargs)
    return {"macos_instance": spec}


def freebsd_instance(image_family="", image_name="", **kwargs):
    """https://cirrus-ci.org/guide/FreeBSD"""
    spec = dict(kwargs.items())
    if image_family != "":
        spec["image_family"] = image_family
    if image_name != "":
        spec["image_name"] = image_name
    return {"freebsd_instance": spec}


def always(instruction):
    return {'always': instruction}


def on_failure(instruction):
    return {'on_failure': instruction}


def on_success(instruction):
    return {'on_success': instruction}


DEFAULT_CLONE_URL = "https://x-access-token:%(CIRRUS_REPO_CLONE_TOKEN)s@github.com/%(CIRRUS_REPO_FULL_NAME)s.git"


def use_deep_clone(existing_task, before=None, url=DEFAULT_CLONE_URL):
    """Add `deep_clone_script` to an existing task.
    By default, the custom `clone_script` is inserted before the first script in the
    task, but you can customize that by providing a instruction name using the `before`
    parameter, e.g., `before="pip_cache"` or `before="run_script"`.
    """
    task_items = existing_task.items()
    for i, (key, value) in enumerate(task_items):
        if (before == None and key.endswith('_script')) or key == before:
            break
    os = "windows" if "windows_container" in existing_task else "posix"
    return dict(task_items[:i] + deep_clone_script(url, os).items() + task_items[i:])


def deep_clone_script(url=DEFAULT_CLONE_URL, os="posix", env=None):
    """Cirrus CI uses go-git for single-branch clones, but some tools might
    expect the '.git' dir to be populated exactly as it is done by default via
    the `git` command.

    This function uses a pre-installed git executable to perform a github clone
    for those use cases. Please use `os="windows"` to create a CMD script.
    """

    env = env or environ  # <- allows overwriting env (facilitates testing)
    pr = env.get("CIRRUS_PR")
    names = [
      "CIRRUS_PR",
      "CIRRUS_REPO_CLONE_TOKEN",
      "CIRRUS_REPO_FULL_NAME",
      "CIRRUS_WORKING_DIR",
      "CIRRUS_CHANGE_IN_REPO",
      "CIRRUS_BRANCH"
    ]
    clone_vars = {v: _env_var(v, os) for v in names}
    clone_vars['CLONE_URL'] = url % clone_vars

    if pr == None or pr == "":
        commands = [
            "git clone --recursive --branch=%(CIRRUS_BRANCH)s %(CLONE_URL)s %(CIRRUS_WORKING_DIR)s" % clone_vars,
            "git reset --hard %(CIRRUS_CHANGE_IN_REPO)s" % clone_vars,
        ]
    else:
        commands = [
            "git clone --recursive %(CLONE_URL)s %(CIRRUS_WORKING_DIR)s" % clone_vars,
            "git fetch origin pull/%(CIRRUS_PR)s/head:pull/%(CIRRUS_PR)s" % clone_vars,
            "git reset --hard %(CIRRUS_CHANGE_IN_REPO)s" % clone_vars,
        ]
    return script("clone", *commands)

def _env_var(name, os="posix"):
    markers = {"windows": ("%", "%"), "posix": ("${", "}")}
    prefix, suffix = markers.get(os) or fail("os=%r not supported" % os)
    return prefix + name + suffix
