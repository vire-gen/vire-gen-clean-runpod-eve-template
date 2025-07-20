# Stage 1: Base Image
ARG BASE_IMAGE=ashleykza/a1111:1.10.0.post7
FROM ${BASE_IMAGE} AS base

ARG INDEX_URL

# Stage 2: InvokeAI Installation
FROM base AS invokeai-install
ARG INVOKEAI_VERSION
ARG INVOKEAI_TORCH_VERSION
ARG INVOKEAI_XFORMERS_VERSION
WORKDIR /
COPY --chmod=755 build/install_invokeai.sh ./
RUN /install_invokeai.sh && rm /install_invokeai.sh

# Copy InvokeAI config file
COPY invokeai/invokeai.yaml /InvokeAI/

# Stage 3: ComfyUI Installation
FROM invokeai-install AS comfyui-install
ARG COMFYUI_VERSION
ARG COMFYUI_TORCH_VERSION
ARG COMFYUI_XFORMERS_VERSION
WORKDIR /
COPY --chmod=755 build/install_comfyui.sh ./
RUN /install_comfyui.sh && rm /install_comfyui.sh

# Copy ComfyUI Extra Model Paths (to share models with A1111)
COPY comfyui/extra_model_paths.yaml /ComfyUI/

# Stage 5: Tensorboard Installation
FROM comfyui-install AS tensorboard-install
WORKDIR /
COPY --chmod=755 build/install_tensorboard.sh ./
RUN /install_tensorboard.sh && rm /install_tensorboard.sh

# Stage 6: Finalise Image
FROM tensorboard-install AS final

# Remove existing SSH host keys
RUN rm -f /etc/ssh/ssh_host_*

# NGINX Proxy config
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Application Manager config
COPY app-manager/config.json /app-manager/public/config.json

# Set template version
ARG RELEASE
ENV TEMPLATE_VERSION=${RELEASE}

# Set the main venv path
ARG VENV_PATH
ENV VENV_PATH=${VENV_PATH}

# Copy the scripts
WORKDIR /
COPY --chmod=755 scripts/* ./

# Start the container
SHELL ["/bin/bash", "--login", "-c"]
CMD [ "/start.sh" ]
