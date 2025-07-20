#!/bin/bash

echo ">> Starting pre-checks..."
bash ./scripts/pre_start.sh

echo ">> Starting InvokeAI..."
bash ./scripts/start_invokeai.sh &

echo ">> Starting ComfyUI..."
bash ./scripts/start_comfyui.sh &

echo ">> Starting Tensorboard (if enabled)..."
if [ "$ENABLE_TENSORBOARD" = "1" ]; then
    bash ./scripts/start_tensorboard.sh &
fi

echo ">> All services launched. Ready to roll ✨"
wait
