import yaml
import os

with open("config/main.yml", "r") as f:
    config = yaml.safe_load(f)

with open(".env", "w") as f:
    for key, value in config.items():
        if isinstance(value, str):
            f.write(f"export {key.upper()}='{value}'\n")
        else:
            f.write(f"export {key.upper()}={value}\n")
