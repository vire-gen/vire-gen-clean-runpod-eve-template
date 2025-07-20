#!/bin/bash

echo ">> Starting pre-checks..."
bash ./pre_start.sh

echo ">> Starting InvokeAI..."
bash ./start_invokeai.sh &

echo ">> Starting ComfyUI..."
bash ./start_comfyui.sh &

echo ">> Starting Tensorboard (if enabled)..."
if [ "$ENABLE_TENSORBOARD" = "1" ]; then
    bash ./start_tensorboard.sh &
fi

echo ">> All services launched. Ready to roll ✨"
wait
