#!/bin/bash
set -e

# setup ros2 environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
source "/opt/overlay_ws/install/setup.bash"
exec "$@"
