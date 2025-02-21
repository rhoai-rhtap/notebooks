ARG BASE_IMAGE
FROM ${BASE_IMAGE}

LABEL name="odh-notebook-cuda-c9s-python-3.9" \
      summary="CUDA Python 3.9 base image for ODH notebooks" \
      description="CUDA Python 3.9 builder image based on CentOS Stream 9 for ODH notebooks" \
      io.k8s.display-name="CUDA Python 3.9 base image for ODH notebooks" \
      io.k8s.description="CUDA Python 3.9 builder image based on C9S for ODH notebooks" \
      authoritative-source-url="https://github.com/opendatahub-io/notebooks" \
      io.openshift.build.commit.ref="main" \
      io.openshift.build.source-location="https://github.com/opendatahub-io/notebooks/tree/main/cuda/c9s-python-3.9" \
      io.openshift.build.image="quay.io/opendatahub/workbench-images:cuda-c9s-python-3.9"

# Install CUDA base from:
# https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.8.0/ubi8/base/Dockerfile
USER 0
WORKDIR /opt/app-root/bin

ENV NVARCH x86_64
ENV NVIDIA_REQUIRE_CUDA "cuda>=11.8 brand=tesla,driver>=450,driver<451 brand=tesla,driver>=470,driver<471 brand=unknown,driver>=470,driver<471 brand=nvidia,driver>=470,driver<471 brand=nvidiartx,driver>=470,driver<471 brand=geforce,driver>=470,driver<471 brand=geforcertx,driver>=470,driver<471 brand=quadro,driver>=470,driver<471 brand=quadrortx,driver>=470,driver<471 brand=titan,driver>=470,driver<471 brand=titanrtx,driver>=470,driver<471"
ENV NV_CUDA_CUDART_VERSION 11.8.89-1

COPY cuda.repo-x86_64 /etc/yum.repos.d/cuda.repo

RUN NVIDIA_GPGKEY_SUM=d0664fbbdb8c32356d45de36c5984617217b2d0bef41b93ccecd326ba3b80c87 && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/rhel8/${NVARCH}/D42D0685.pub | sed '/^Version/d' > /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA && \
    echo "$NVIDIA_GPGKEY_SUM  /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA" | sha256sum -c --strict -

ENV CUDA_VERSION 11.8.0

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN yum upgrade -y && yum install -y \
    cuda-cudart-11-8-${NV_CUDA_CUDART_VERSION} \
    cuda-compat-11-8 \
    && yum clean all \
    && rm -rf /var/cache/yum/*

# nvidia-docker 1.0
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

COPY NGC-DL-CONTAINER-LICENSE /

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

# Install CUDA runtime from:
# https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.8.0/ubi8/runtime/Dockerfile
ENV NV_CUDA_LIB_VERSION 11.8.0-1
ENV NV_NVTX_VERSION 11.8.86-1
ENV NV_LIBNPP_VERSION 11.8.0.86-1
ENV NV_LIBNPP_PACKAGE libnpp-11-8-${NV_LIBNPP_VERSION}
ENV NV_LIBCUBLAS_VERSION 11.11.3.6-1
ENV NV_LIBNCCL_PACKAGE_NAME libnccl
ENV NV_LIBNCCL_PACKAGE_VERSION 2.15.5-1
ENV NV_LIBNCCL_VERSION 2.15.5
ENV NCCL_VERSION 2.15.5
ENV NV_LIBNCCL_PACKAGE ${NV_LIBNCCL_PACKAGE_NAME}-${NV_LIBNCCL_PACKAGE_VERSION}+cuda11.8

RUN yum install -y \
    cuda-libraries-11-8-${NV_CUDA_LIB_VERSION} \
    cuda-nvtx-11-8-${NV_NVTX_VERSION} \
    ${NV_LIBNPP_PACKAGE} \
    libcublas-11-8-${NV_LIBCUBLAS_VERSION} \
    ${NV_LIBNCCL_PACKAGE} \
    && yum clean all \
    && rm -rf /var/cache/yum/*

# Install CUDA devel from:
# https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.8.0/ubi8/devel/Dockerfile
ENV NV_CUDA_LIB_VERSION 11.8.0-1
ENV NV_NVPROF_VERSION 11.8.87-1
ENV NV_NVPROF_DEV_PACKAGE cuda-nvprof-11-8-${NV_NVPROF_VERSION}
ENV NV_CUDA_CUDART_DEV_VERSION 11.8.89-1
ENV NV_NVML_DEV_VERSION 11.8.86-1
ENV NV_LIBCUBLAS_DEV_VERSION 11.11.3.6-1
ENV NV_LIBNPP_DEV_VERSION 11.8.0.86-1
ENV NV_LIBNPP_DEV_PACKAGE libnpp-devel-11-8-${NV_LIBNPP_DEV_VERSION}
ENV NV_LIBNCCL_DEV_PACKAGE_NAME libnccl-devel
ENV NV_LIBNCCL_DEV_PACKAGE_VERSION 2.15.5-1
ENV NCCL_VERSION 2.15.5
ENV NV_LIBNCCL_DEV_PACKAGE ${NV_LIBNCCL_DEV_PACKAGE_NAME}-${NV_LIBNCCL_DEV_PACKAGE_VERSION}+cuda11.8

RUN yum install -y \
    make \
    cuda-command-line-tools-11-8-${NV_CUDA_LIB_VERSION} \
    cuda-libraries-devel-11-8-${NV_CUDA_LIB_VERSION} \
    cuda-minimal-build-11-8-${NV_CUDA_LIB_VERSION} \
    cuda-cudart-devel-11-8-${NV_CUDA_CUDART_DEV_VERSION} \
    ${NV_NVPROF_DEV_PACKAGE} \
    cuda-nvml-devel-11-8-${NV_NVML_DEV_VERSION} \
    libcublas-devel-11-8-${NV_LIBCUBLAS_DEV_VERSION} \
    ${NV_LIBNPP_DEV_PACKAGE} \
    ${NV_LIBNCCL_DEV_PACKAGE} \
    && yum clean all \
    && rm -rf /var/cache/yum/*

ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

# Install CUDA devel cudnn8 from:
# https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.8.0/ubi8/devel/cudnn8/Dockerfile
ENV NV_CUDNN_VERSION 8.9.0.131-1
ENV NV_CUDNN_PACKAGE libcudnn8-${NV_CUDNN_VERSION}.cuda11.8
ENV NV_CUDNN_PACKAGE_DEV libcudnn8-devel-${NV_CUDNN_VERSION}.cuda11.8

LABEL com.nvidia.cudnn.version="${NV_CUDNN_VERSION}"

RUN yum install -y \
    ${NV_CUDNN_PACKAGE} \
    ${NV_CUDNN_PACKAGE_DEV} \
    && yum clean all \
    && rm -rf /var/cache/yum/*

# Install CUDA toolkit 11.8
RUN yum -y install cuda-toolkit-11-8 && \
    yum -y clean all --enablerepo="*"

# Set this flag so that libraries can find the location of CUDA
ENV XLA_FLAGS=--xla_gpu_cuda_data_dir=/usr/local/cuda

# Restore notebook user workspace
USER 1001
WORKDIR /opt/app-root/src
