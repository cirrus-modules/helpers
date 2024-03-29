load("../../lib.star", "powershell", "task", "windows_container")

def main():
    return [
        task("task default windows container", windows_container()),
        task(
            "task custom windows container",
            windows_container("cirrusci/windowsservercore:visualstudio2019"),
        ),
        task(
            "task custom windows container custom version",
            windows_container("python:3.8-windowsservercore", "2019"),
            instructions = [powershell("debug", "Get-Location")],
        ),
        task(
            "task with unnamed powershell script",
            windows_container("python:3.8-windowsservercore", "2019"),
            instructions = [powershell("Get-Location")],
        ),
    ]
