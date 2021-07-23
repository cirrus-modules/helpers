load("../../lib.star", "task", "windows_container")

def main(ctx):
    return [
        task("task default windows container", windows_container()),
        task("task custom windows container",
             windows_container("cirrusci/windowsservercore:visualstudio2019")),
        task("task custom windows container custom version",
             windows_container("python:3.8-windowsservercore", "2019")),
    ]
