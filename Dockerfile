# A Dockerfile to build librealsense and Foxy for arm devices
ARG ROS_DISTRO=foxy
ARG BASE_IMAGE=ros:$ROS_DISTRO
FROM $BASE_IMAGE

SHELL ["/bin/bash", "-c"]

WORKDIR /opt/overlay_ws/src
RUN git clone -b v2.42.0 --depth 1 https://github.com/IntelRealSense/librealsense \
    && git clone -b foxy --depth 1 https://github.com/IntelRealSense/realsense-ros.git
WORKDIR /opt/overlay_ws
RUN source /opt/ros/$ROS_DISTRO/setup.bash \
    && sudo apt-get update \
    && rosdep update \
    && rosdep install -y --from-paths src --ignore-src --skip-keys=catkin \
    && rm -rf /var/lib/apt/lists/*
RUN source /opt/ros/$ROS_DISTRO/setup.bash \
    && colcon build --event-handlers console_direct+ --cmake-args " -DFORCE_RSUSB_BACKEND=ON" " -DBUILD_NETWORK_DEVICE=ON" " -DBUILD_EXAMPLES=false" " -DBUILD_GRAPHICAL_EXAMPLES=false"
COPY assets/ros_entrypoint.sh /ros_entrypoint.sh
ENTRYPOINT ["/ros_entrypoint.sh"]
