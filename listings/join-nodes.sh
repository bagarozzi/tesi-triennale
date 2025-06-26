JOIN_CMD=$(ssh_exec "$MASTER_IP" "sudo kubeadm token create --print-join-command 2>/dev/null" || echo "")

[...]

for worker_ip in "${WORKER_IPS[@]}"; do
    log "Joining worker node: $worker_ip"
    
    # Execute join command on worker
    if ssh_exec "$worker_ip" "sudo $JOIN_CMD"; then
        log "Successfully joined worker node: $worker_ip"
        
        # Wait a moment for node to register
        sleep 5
        
        # Verify the node joined successfully
        NODE_STATUS=$(ssh_exec "$MASTER_IP" "kubectl get nodes --no-headers | grep '$worker_ip' | awk '{print \$2}'" || echo "Unknown")
        log "Node $worker_ip status: $NODE_STATUS"
        
    else
        log "Failed to join worker node: $worker_ip"
        ((FAILED_JOINS++))
    fi
    
    echo "----------------------------------------"
done