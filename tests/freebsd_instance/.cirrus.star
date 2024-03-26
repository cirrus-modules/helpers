load("../../lib.star", "task", "freebsd_instance")

def main(ctx):
    return [
        task("freebsd task", freebsd_instance("freebsd-13-0")),
        task("freebsd task with image_name",
             freebsd_instance(image_name="family/freebsd-13-0")),
    ]
