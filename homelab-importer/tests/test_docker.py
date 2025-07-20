import unittest
from unittest.mock import mock_open, patch
import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'src')))
from docker import generate_docker_compose

class TestDocker(unittest.TestCase):
    def test_generate_docker_compose(self):
        containers = [
            {
                "name": "test-container-1",
                "attributes": {
                    "image": "test-image-1",
                    "restart": "always",
                    "ports": ["8080:80"],
                },
            },
            {
                "name": "test-container-2",
                "attributes": {
                    "image": "test-image-2",
                    "restart": "unless-stopped",
                    "ports": ["9090:90"],
                },
            },
        ]

        m = mock_open()
        with patch("builtins.open", m), patch("yaml.dump") as mock_dump:
            generate_docker_compose(containers, "docker-compose.yml")

        m.assert_called_once_with("docker-compose.yml", "w")
        handle = m()
        mock_dump.assert_called_once()

if __name__ == "__main__":
    unittest.main()
